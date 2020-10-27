class Business::BanksController < ApplicationController
  def new
    @account = StripeAccount.find(params[:account_id])
    if @account.present?
      if qualified(@account.user)
        @ext_acct_form = StripeExtAccountForm.new
      else
        redirect_to user_path(current_user.id), alert: 'アカウントを作成するユーザー条件を満たしていません。' and return
      end
    else
      redirect_to user_path(current_user.id), alert: 'ご本人様情報を先に登録して下さい。' and return
    end
  end

  def create
    @account = StripeAccount.find(params[:account_id])
    @ext_acct_form = StripeExtAccountForm.new(create_params)
    if @ext_acct_form.valid?
      @stripe_bank_inputs = @ext_acct_form.create_bank_inputs
      if @stripe_bank_inputs[0]
        @new_stripe_ba_hash = @account.create_ext_account(@stripe_bank_inputs[1])
        if @new_stripe_ba_hash[0]
          if @account.update(ext_acct_id: @new_stripe_ba_hash[1]['id'])
            redirect_to account_path(@account.id), notice: '銀行口座情報を登録しました。'
          else
            Rails.logger.error "Active Record save returned false. @new_stripe_ba_hash = #{@new_stripe_ba_hash}"
            redirect_to account_path(@account.id), alert: '銀行口座の登録に失敗しました。'
          end
        else
          Rails.logger.error "create_ext_account returned false : #{@new_stripe_ba_hash[1]}"
          redirect_to user_path(@account.user_id), alert: '銀行口座の登録に失敗しました。' and return
        end
      else
        Rails.logger.error "create_bank_inputs returned false : #{@stripe_bank_inputs[1]}"
        redirect_to account_path(@account.id), alert: "入力情報に誤りがあります。#{@stripe_bank_inputs[1]}" and return
      end
    else
      render :new
    end
  end

  def edit
    @account = StripeAccount.find(params[:account_id])
    @bank_info = @account.get_ext_account
    if @bank_info[0]
      @ext_acct_form = StripeExtAccountForm.new
      @ext_acct_form.set_info(@bank_info[1])
    end
  end

  def update
    @account = StripeAccount.find(params[:account_id])
    @old_stripe_bank_id = @account.ext_acct_id
    @ext_acct_form = StripeExtAccountForm.new(create_params)
    if @ext_acct_form.valid?
      @stripe_bank_inputs = @ext_acct_form.create_bank_inputs
      if @stripe_bank_inputs[0]
        # 新しい口座情報をStripeに登録しdefault accountに指定
        @new_stripe_ba_hash = @account.create_ext_account(@stripe_bank_inputs[1])
        if @new_stripe_ba_hash[0]
          @account.update(ext_acct_id: @new_stripe_ba_hash[1]['id'])
          # 古い口座情報をStripeか���削除。注意：上のように先に新しいdefault accountを追加しておかないとエラーで弾かれる
          @old_stripe_ba_hash = @account.delete_ext_account(@old_stripe_bank_id)
          if @old_stripe_ba_hash[0]
            redirect_to account_path(@account.id), notice: '銀行口座情報を更新しました。' and return
          else
            Rails.logger.error "delete_ext_account returned false : #{@old_stripe_ba_hash[1]}"
            redirect_to edit_externalaccount_path(params[:id]), alert: '銀行口座の更新に失敗しました。' and return
          end
        else
          Rails.logger.error "create_ext_account returned false : #{@new_stripe_ba_hash[1]}"
          redirect_to edit_externalaccount_path(params[:id]), alert: '銀行口座の更新に失敗しました。' and return
        end
      else
        Rails.logger.error "create_bank_inputs returned false : #{@stripe_bank_inputs[1]}"
        redirect_to account_path(@account.id), alert: "入力情報に誤りがあります。#{@stripe_bank_inputs[1]}" and return
      end
    else
      Rails.logger.error "create_bank_inputs returned false : #{@stripe_bank_inputs[1]}"
      redirect_to edit_externalaccount_path(params[:id]), alert: "銀行口座の更新に失敗しました。#{@stripe_bank_inputs[1]}" and return
    end
  end

  private

  def create_params
    params.require(:stripe_ext_account_form).permit(:bank_name, :branch_name, :account_number, :account_holder_name)
  end

  def qualified(user)
    if current_user.id == user.id && current_user.premium_user[0]
      true
    else
      false
    end
  end
end
