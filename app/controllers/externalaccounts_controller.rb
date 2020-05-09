class ExternalaccountsController < ApplicationController
  
  def new
    begin
      @account = Account.find(params[:account_id])
      if @account.present?
        if qualified(@account.user)
          @ext_acct = Externalaccount.new
        else
          redirect_to user_path(current_user.id), alert: "アカウントを作成するユーザー条件を満たしていません。" and return
        end
      else
        redirect_to user_path(current_user.id), alert: "ご本人様情報を先に登録して下さい。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:account_id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def create
    begin
      @account = Account.find(params[:account_id])
      @stripe_bank_inputs = create_stripe_bank_inputs
      if @stripe_bank_inputs[0]
        @ext_acct = Externalaccount.new(account_id: @account.id)
        @new_stripe_ba_hash = @ext_acct.create_stripe_ext_account(@stripe_bank_inputs[1])
        if @new_stripe_ba_hash[0]
          @ext_acct.save!(stripe_bank_id: @new_stripe_ba_hash[1]["id"])
          redirect_to account_path(@account.id), notice: "銀行口座情報を登録しました。"
        else
          Rails.logger.error "create_stripe_ext_account returned false : #{@new_stripe_ba_hash[1]}"
          redirect_to user_path(@account.user_id), alert: "銀行口座の登録に失敗しました。" and return
        end
      else
        Rails.logger.error "create_stripe_bank_inputs returned false : #{@stripe_bank_inputs[1]}"
        redirect_to account_path(@account.id), alert: "入力情報に誤りがあります。#{@stripe_bank_inputs[1]}" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:account_id]), alert: "システムエラーが発生しました。" and return
    end
  end
  
  def edit
    begin
      @ext_acct = Externalaccount.find(params[:id])
      @bank_info = @ext_acct.get_stripe_ext_account
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(current_user.account.id), alert: "エラーが発生しました。" and return
    end
  end
  
  def update
    begin
      @ext_acct = Externalaccount.find(params[:id])
      @old_stripe_bank_id = @ext_acct.stripe_bank_id
      @stripe_bank_inputs = create_stripe_bank_inputs
      
      if @stripe_bank_inputs[0]
        # 新しい口座情報をStripeに登録しdefault accountに指定
        @new_stripe_ba_hash = @ext_acct.create_stripe_ext_account(@stripe_bank_inputs[1])
        if @new_stripe_ba_hash[0]
          @ext_acct.update!(stripe_bank_id: @new_stripe_ba_hash[1]["id"])
          # 古い口座情報をStripeから削除。注意：上のように先に新しいdefault accountを追加しておかないとエラーで弾かれる
          @old_stripe_ba_hash = @ext_acct.delete_stripe_ext_account(@old_stripe_bank_id)
          if @old_stripe_ba_hash[0]
            redirect_to account_path(@ext_acct.account.id), notice: "銀行口座情報を更新しました。" and return
          else
            Rails.logger.error "delete_stripe_ext_account returned false : #{@old_stripe_ba_hash[1]}"
            redirect_to edit_externalaccount_path(params[:id]), alert: "銀行口座の更新に失敗しました。" and return
          end
        else
          Rails.logger.error "create_stripe_ext_account returned false : #{@new_stripe_ba_hash[1]}"
          redirect_to edit_externalaccount_path(params[:id]), alert: "銀行口座の更新に失敗しました。" and return
        end
      else
        Rails.logger.error "create_stripe_bank_inputs returned false : #{@stripe_bank_inputs[1]}"
        redirect_to edit_externalaccount_path(params[:id]), alert: "銀行口座の更新に失敗しました。#{@stripe_bank_inputs[1]}" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to edit_externalaccount_path(params[:id]), alert: "銀行口座の更新に失敗しました。" and return
    end
  end

  def bank_search_autocomplete
    items = Bank.ransack(name_or_namehira_start: params[:keyword]).result.order("namehira ASC").limit(5)
    render json: BankSerializer.new(items)
  end
  
  def branch_search_autocomplete
    bank = Bank.find_by(name: params[:bankname])
    items = bank.branches.ransack(name_or_namehira_start: params[:branchname]).result.order("namehira ASC").limit(5)
    render json: BankSerializer.new(items)
  end

  private
  def create_params
    params.require(:externalaccount).permit(:bank_name, :branch_name, :account_number, :account_holder_name)
  end
  
  def create_stripe_bank_inputs
    if create_params[:bank_name].present? && create_params[:branch_name].present? && create_params[:account_number].present? && create_params[:account_holder_name].present?
      bank = Bank.find_by(name: create_params[:bank_name])
      if bank.present?
        branch = bank.branches.find_by(name: create_params[:branch_name])
        if branch.present?
          ba_params = {
            external_account:
            {
              object:               'bank_account',
              account_number:       create_params[:account_number],
              routing_number:       "#{bank.code}"+"#{branch.code}", #銀行コード4けた+支店コード3けた
              account_holder_name:  create_params[:account_holder_name], #カタカナでなければStripeエラー
              currency:             'jpy',
              country:              'jp',
            },
            default_for_currency: 'true',
          }
          return [true, ba_params]
        else
          return [false, "支店名に誤りがあります。"]
        end
      else
        return [false, "銀行名に誤りがあります。"]
      end
    else
      return [false, "口座情報が不足しています。"]
    end
  end
  
  def qualified(user)
    if current_user.id == user.id && current_user.premium_user[0]
      return true
    else
      return false
    end
  end
end
