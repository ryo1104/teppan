require 'rails_helper'

RSpec.describe NetasController, type: :controller do
  let(:user_create)         { FactoryBot.create(:user) }
  let(:topic_create)        { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)         { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:private_neta_create) { FactoryBot.create(:neta, :with_user, topic: topic_create, private_flag: true) }
  let(:review_create)       { FactoryBot.create(:review, neta: neta_create) }
  let(:neta_attributes)     { FactoryBot.attributes_for(:neta) }
  let(:neta_list_create)    { FactoryBot.create_list(:neta, 5, user: user_create, topic: topic_create) }
  let(:hashtag_list_create) { FactoryBot.create_list(:hashtag, 15, :with_random_hit_count, :with_random_neta_count) }
  let(:pageview_list_create) { FactoryBot.create_list(:pageview, 3, pageviewable: neta_create, user: user_create) }
  # login_user
  # render_views

  describe 'GET #index' do
    context 'as a guest' do
      it 'returns a 200 status code' do
        get :index
        expect(response).to have_http_status('200')
      end
      it 'populates @netas with only public netas' do
        public_netas = neta_list_create
        private_neta_create
        get :index
        expect(assigns(:netas)).to match(public_netas.sort { |a, b| b.created_at <=> a.created_at })
      end
      it 'populates @netas ordered by created_at DESC' do
        netas = neta_list_create
        get :index
        expect(assigns(:netas)).to match(netas.sort { |a, b| b.created_at <=> a.created_at })
      end
      it 'populates @hashtag_ranking' do
        hashtag_list_create
        get :index
        expect(assigns(:hashtag_ranking)).not_to be_empty
      end
      it 'populates @neta_ranking'
      it 'does not populate @view_history' do
        pageview_list_create
        get :index
        expect(assigns(:view_history)).to be nil
      end
    end

    context 'as an authenticated user' do
      # before do
      #   @user = user_create
      # @user.confirm
      # sign_in @user
      # end
      it 'populates @view_history' do
        pageview_list_create
        get :index
        expect(assigns(:view_history)).not_to be_empty
      end
    end

    context 'search functionality' do
      before do
        @data1 = FactoryBot.create(:neta, :with_user, topic: topic_create, text: '検索用テキスト　あああいいいうううえええおおお', price: 50, average_rate: 3.01)
        @data2 = FactoryBot.create(:neta, :with_user, topic: topic_create, text: '検索用テキスト　かかかきききくくくけけけこここ', price: 100, average_rate: 2.99)
        @data3 = FactoryBot.create(:neta, :with_user, topic: topic_create, text: '検索用Text　ABCDEFG HIJKLMN', price: 200, average_rate: 3)
        @user1 = FactoryBot.create(:user, nickname: 'はたけ　カカシ')
        @data4 = FactoryBot.create(:neta, user: @user1, topic: topic_create, text: '検索用Text ABCDEFG HIJKLMN123１２３', price: 300, average_rate: 5)
        @params = {}
        @params[:q] = {}
      end

      it 'filters records that matches keyword' do
        @params[:q][:text_cont] = 'あああ'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data1])
      end

      it "returns 0 records that doesn't match keyword" do
        @params[:q][:text_cont] = 'Text that does not exist in database'
        get :index, params: @params
        expect(assigns(:netas).count).to be 0
      end

      it 'filters records with price at or below specified price' do
        @params[:q][:price_lteq] = '100'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data1, @data2])
      end

      it 'filters records with price at or above specified price' do
        @params[:q][:price_gteq] = '100'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data2, @data3, @data4])
      end

      it 'filters records with price range' do
        @params[:q][:price_gteq] = '100'
        @params[:q][:price_lteq] = '200'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data2, @data3])
      end

      it 'filters records with user nickname' do
        @params[:q][:user_nickname_cont] = 'はたけ　カカシ'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data4])
      end

      it 'filters records with average rate (greater than or equal to)' do
        @params[:q][:average_rate_gteq] = '3'
        get :index, params: @params
        expect(assigns(:netas)).to match_array([@data1, @data3, @data4])
      end
    end
  end

  describe 'GET #new' do
    context 'as an authenticated user' do
      login_user

      before(:each) do
        @topic = topic_create
      end

      it 'populates @topic', type: :doing do
        get :new, params: { topic_id: @topic.id }
        expect(assigns(:topic)).to eq @topic
      end

      it 'populates @qualified ' do
        get :new, params: { topic_id: @topic.id }
        expect(assigns(:qualified)).to_not be nil
      end

      it 'populates @stale_form_check_timestamp ' do
        get :new, params: { topic_id: @topic.id }
        expect(assigns(:stale_form_check_timestamp)).to eq Time.zone.now.to_i
      end

      it 'renders the :new template' do
        get :new, params: { topic_id: @topic.id }
        expect(response).to render_template :new
      end

      it 'returns a 200 status code' do
        get :new, params: { topic_id: @topic.id }
        expect(response).to have_http_status('200')
      end
    end

    context 'as a guest' do
      # before(:each) do
      #   @topic = topic_create
      # end

      it 'returns a 302 status code' do
        @topic = topic_create
        get :new, params: { topic_id: @topic.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to the sign-in page' do
        @topic = topic_create
        get :new, params: { topic_id: @topic.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'POST #create' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @attributes = neta_attributes
      end

      it 'returns a 302 status code' do
        post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        expect(response).to have_http_status('302')
      end

      it 'creates a neta' do
        expect do
          post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        end.to change(Neta, :count).by(1)
      end

      it 'populates @stale_form_check_timestamp' do
        post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        expect(assigns(:stale_form_check_timestamp)).to eq Time.zone.now.to_i
      end

      it 'redirects to topic#show template' do
        post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        expect(response).to redirect_to "/topics/#{@topic.id}"
      end
    end

    context 'as a guest' do
      before do
        @topic = topic_create
        @attributes = neta_attributes
      end

      it 'returns a 302 status code' do
        post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        post :create, params: { topic_id: @topic.id, text: @attributes[:text], price: @attributes[:price] }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET #show' do
    context 'as authenticated user' do
      before do
        @user = user_create
        sign_in @user
        allow(controller).to receive(:current_user).and_return(@user)
      end
      context 'and non-owner' do
        before do
          @neta = FactoryBot.create(:neta, :with_user, topic: topic_create)
        end
        it 'populates @owner as false' do
          get :show, params: { id: @neta.id }
          expect(assigns(:owner)).to eq false
        end
        context 'when private flag set to true' do
          it 'blocks display with message' do
            @neta = FactoryBot.create(:neta, :with_user, topic: topic_create, private_flag: true)
            get :show, params: { id: @neta.id }
            expect(assigns(:message)).to eq 'このネタは投稿者が非公開に設定しています。'
          end
          it 'returns a 200 status code' do
            @neta = FactoryBot.create(:neta, :with_user, topic: topic_create, private_flag: true)
            get :show, params: { id: @neta.id }
            expect(response).to have_http_status('200')
          end
        end
        it 'populates @reviews' do
          reviews = create_list(:review, 5, :with_user, neta: @neta)
          get :show, params: { id: @neta.id }
          expect(assigns(:reviews)).to match(reviews)
        end
        it 'populates @myreviews' do
          create_list(:review, 3, :with_user, neta: @neta)
          myreview = create(:review, user: @user, neta: @neta)
          get :show, params: { id: @neta.id }
          expect(assigns(:myreview)).to match_array(myreview)
        end
        it 'populates @for_sale when neta price is not zero' do
          @neta = create(:neta, :with_user, topic: topic_create, price: 300)
          get :show, params: { id: @neta.id }
          expect(assigns(:for_sale)).to_not be nil
        end
        it 'populates @for_sale as nil when neta price is zero' do
          @neta = create(:neta, :with_user, topic: topic_create, price: 0)
          get :show, params: { id: @neta.id }
          expect(assigns(:for_sale)).to be nil
        end
        it 'populates @purchased when my trade exists' do
          create_list(:trade, 3, tradeable: @neta)
          mytrade = create(:trade, tradeable: @neta, buyer_id: @user.id)
          get :show, params: { id: @neta.id }
          expect(assigns(:purchased)).to match(mytrade)
        end
        it 'returns nil for @purchased when my trade does not exist' do
          create_list(:trade, 3, tradeable: @neta)
          get :show, params: { id: @neta.id }
          expect(assigns(:purchased)).to be nil
        end
        it 'adds pageview' do
          expect do
            get :show, params: { id: @neta.id }
          end.to change(Pageview, :count).by(1)
        end
        it 'renders the :show template' do
          get :show, params: { id: @neta.id }
          expect(response).to render_template :show
        end
        it 'returns a 200 status code' do
          get :show, params: { id: @neta.id }
          expect(response).to have_http_status('200')
        end
      end
      context 'and owner' do
        before do
          @neta = FactoryBot.create(:neta, user: @user, topic: topic_create)
        end
        it 'populates @owner as true' do
          get :show, params: { id: @neta.id }
          expect(assigns(:owner)).to eq true
        end
        it 'populates @reviews' do
          reviews = create_list(:review, 5, :with_user, neta: @neta)
          get :show, params: { id: @neta.id }
          expect(assigns(:reviews)).to match(reviews)
        end
        it 'populates @myreviews' do
          create_list(:review, 3, :with_user, neta: @neta)
          myreview = create(:review, user: @user, neta: @neta)
          get :show, params: { id: @neta.id }
          expect(assigns(:myreview)).to match_array(myreview)
        end
        it 'populates @for_sale when neta price is not zero' do
          @neta = create(:neta, :with_user, topic: topic_create, price: 300)
          get :show, params: { id: @neta.id }
          expect(assigns(:for_sale)).to_not be nil
        end
        it 'populates @for_sale as nil when neta price is zero' do
          @neta = create(:neta, :with_user, topic: topic_create, price: 0)
          get :show, params: { id: @neta.id }
          expect(assigns(:for_sale)).to be nil
        end
        it 'renders the :show template' do
          get :show, params: { id: @neta.id }
          expect(response).to render_template :show
        end
        it 'returns a 200 status code' do
          get :show, params: { id: @neta.id }
          expect(response).to have_http_status('200')
        end
      end
    end

    context 'as a guest' do
      before do
        @neta = neta_create
      end

      it 'returns a 302 status code' do
        get :show, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        get :show, params: { id: @neta.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET #edit' do
    context 'as a neta owner' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        allow_any_instance_of(Neta).to receive(:owner).and_return(true)
      end

      it 'populates @neta' do
        get :edit, params: { id: @neta.id }
        expect(assigns(:neta)).to eq @neta
      end

      it 'populates @editable' do
        get :edit, params: { id: @neta.id }
        expect(assigns(:editable)).to_not be nil
      end

      it 'populates @qualified' do
        get :edit, params: { id: @neta.id }
        expect(assigns(:qualified)).to_not be nil
      end

      it 'returns a 200 status code' do
        get :edit, params: { id: @neta.id }
        expect(response).to have_http_status('200')
      end

      it 'renders the :edit template' do
        get :edit, params: { id: @neta.id }
        expect(response).to render_template :edit
      end
    end

    context 'not as a neta owner' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        allow_any_instance_of(Neta).to receive(:owner).and_return(false)
      end

      it 'populates @neta' do
        get :edit, params: { id: @neta.id }
        expect(assigns(:neta)).to eq @neta
      end

      it 'returns a 302 status code' do
        get :edit, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to neta#show' do
        get :edit, params: { id: @neta.id }
        expect(response).to redirect_to neta_path(@neta.id)
      end
    end

    context 'as a guest' do
      before do
        @neta = neta_create
      end

      it 'returns a 302 status code' do
        get :edit, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        get :edit, params: { id: @neta.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #update' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
      end

      it 'populates @neta' do
        patch :update, params: { id: @neta.id }
        expect(assigns(:neta)).to eq @neta
      end

      it 'updates a neta' do
        # initial_count = Neta.count
        # puts "initial_count : #{initial_count}"
        expect  do
          patch :update, params: { id: @neta.id, text: 'Text for neta controller update', price: 200 }
        end.to change(Neta, :count).by(0)
        # final_count = Neta.count
        # puts "final_count : #{final_count}"
      end

      it 'changes text' do
        patch :update, params: { id: @neta.id, text: 'Text for neta controller update action' }
        expect(@neta.reload.text).to eq 'Text for neta controller update action'
      end

      it 'changes price' do
        patch :update, params: { id: @neta.id, price: 200 }
        expect(@neta.reload.price).to eq 200
      end

      it 'changes valuetext' do
        patch :update, params: { id: @neta.id, valuetext: 'Valuetext for neta controller update action' }
        expect(@neta.reload.valuetext).to eq 'Valuetext for neta controller update action'
      end

      it 'redirects to show action' do
        patch :update, params: { id: @neta.id }
        expect(response).to redirect_to neta_path(@neta.id)
      end
    end

    context 'as a guest' do
      before do
        @neta = neta_create
      end

      it 'returns a 302 status code' do
        patch :update, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        patch :update, params: { id: @neta.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a neta owner' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        allow_any_instance_of(Neta).to receive(:owner).and_return(true)
      end

      it 'populates @neta' do
        delete :destroy, params: { id: @neta.id }
        expect(assigns(:neta)).to eq @neta
      end

      it 'deletes a neta' do
        allow_any_instance_of(Neta).to receive(:has_dependents).and_return(false)
        expect { delete :destroy, params: { id: @neta.id } }.to change(Neta, :count).by(-1)
      end

      it 'redirects to topic when successfully deleted' do
        allow_any_instance_of(Neta).to receive(:has_dependents).and_return(false)
        delete :destroy, params: { id: @neta.id }
        expect(response).to redirect_to topic_path(@neta.topic_id)
      end

      it 'returns a 302 status code' do
        allow_any_instance_of(Neta).to receive(:has_dependents).and_return(false)
        delete :destroy, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to neta when dependent records exist' do
        allow_any_instance_of(Neta).to receive(:has_dependents).and_return(true)
        delete :destroy, params: { id: @neta.id }
        expect(response).to redirect_to neta_path(@neta.id)
      end

      it 'returns a 302 status code when dependent records exist' do
        allow_any_instance_of(Neta).to receive(:has_dependents).and_return(true)
        delete :destroy, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end
    end

    context 'not as a neta owner' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        allow_any_instance_of(Neta).to receive(:owner).and_return(false)
      end
      it 'returns a 302 status code' do
        delete :destroy, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to neta when not owner' do
        delete :destroy, params: { id: @neta.id }
        expect(response).to redirect_to neta_path(@neta.id)
      end
    end

    context 'as a guest' do
      before do
        @neta = neta_create
      end

      it 'returns a 302 status code' do
        delete :destroy, params: { id: @neta.id }
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        delete :destroy, params: { id: @neta.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
