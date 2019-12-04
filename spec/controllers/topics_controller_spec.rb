require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  let(:user_create)           { FactoryBot.create(:user) }
  let(:topic_create)          { FactoryBot.create(:topic, :with_user) }
  let(:topic_list_create)     { FactoryBot.create_list(:topic, 5, :with_user) }
  let(:topic_attributes)      { FactoryBot.attributes_for(:topic) }
  let(:neta_create)           { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:hashtag_list_create)   { FactoryBot.create_list(:hashtag, 15, :with_random_hit_count, :with_random_neta_count) }
  let(:pageview_list_create)  { FactoryBot.create_list(:pageview, 3, pageviewable: neta_create, user: user_create) }
  render_views
  
  describe "GET #index" do
    context "as a guest" do
      it "returns a 200 status code" do
        get :index
        expect(response).to have_http_status("200")
      end
      it "populates @topics ordered by created_at DESC" do
        topics = topic_list_create
        get :index
        expect(assigns(:topics)).to match(topics.sort{|a, b| b.created_at <=> a.created_at})
      end
      it "populates @hashtag_ranking" do
        hashtag_list_create
        get :index
        expect(assigns(:hashtag_ranking)).not_to be_empty
      end
      context "search functionality" do
        before do
          @user1 = FactoryBot.create(:user, nickname: "はたけ　カカシ")
          @user2 = FactoryBot.create(:user, nickname: "うちは　イタチ")
          @user3 = FactoryBot.create(:user, nickname: "ウズマキ　ナルト")
          @topic1 = FactoryBot.create(:topic, user: @user1, title: "検索用タイトル１", text: "検索用テキスト　あああいいいうううえええおおお")
          @topic2 = FactoryBot.create(:topic, user: @user2, title: "検索用タイトル２", text: "検索用テキスト　あああかかかうううけけけおおお")
          @neta1 = FactoryBot.create(:neta, :with_user, topic: @topic1, text: "検索用テキスト　あああいいいうううえええおおお", price: 50, average_rate: 3.01)
          @neta2 = FactoryBot.create(:neta, :with_user, topic: @topic1, text: "検索用テキスト　かかかきききくくくけけけこここ", price: 100, average_rate: 2.99)
          @neta3 = FactoryBot.create(:neta, :with_user, topic: @topic2, text: "検索用テキスト　検索用Text ABCDEFG HIJKLMN123１２３", price: 200, average_rate: 0)
          @neta4 = FactoryBot.create(:neta, user: @user3, topic: @topic1, text: "検索用Text ABCDEFG HIJKLMN123１２３", price: 300, average_rate: 5)
          @params = {}
          @params[:q] = {}
        end
        it "filters topics that matches keyword by title" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'あああ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1, @topic2])
        end
        it "filters topics that matches keyword by text" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'けけけ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1, @topic2])
        end
        it "filters topics that matches keyword by nickname" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'イタチ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic2])
        end
        it "filters topics that have neta count equal or more" do
          @params[:q][:netas_count_gteq] = '3'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1])
        end
        it "returns 0 records that doesn't match keyword" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'Text that does not exist in database'
          get :index, params: @params
          expect(assigns(:topics).count).to be 0
        end
        it "returns 0 records that doesn't match neta count" do
          @params[:q][:netas_count_gteq] = '4'
          get :index, params: @params
          expect(assigns(:topics).count).to be 0
        end
      end
    end
    context "as a authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      it "returns a 200 status code" do
        get :index
        expect(response).to have_http_status("200")
      end
      it "populates @topics ordered by created_at DESC" do
        topics = topic_list_create
        get :index
        expect(assigns(:topics)).to match(topics.sort{|a, b| b.created_at <=> a.created_at})
      end
      it "populates @hashtag_ranking" do
        hashtag_list_create
        get :index
        expect(assigns(:hashtag_ranking)).not_to be_empty
      end
      context "search functionality" do
        before do
          @user1 = FactoryBot.create(:user, nickname: "はたけ　カカシ")
          @user2 = FactoryBot.create(:user, nickname: "うちは　イタチ")
          @user3 = FactoryBot.create(:user, nickname: "ウズマキ　ナルト")
          @topic1 = FactoryBot.create(:topic, user: @user1, title: "検索用タイトル１", text: "検索用テキスト　あああいいいうううえええおおお")
          @topic2 = FactoryBot.create(:topic, user: @user2, title: "検索用タイトル２", text: "検索用テキスト　あああかかかうううけけけおおお")
          @neta1 = FactoryBot.create(:neta, :with_user, topic: @topic1, text: "検索用テキスト　あああいいいうううえええおおお", price: 50, average_rate: 3.01)
          @neta2 = FactoryBot.create(:neta, :with_user, topic: @topic1, text: "検索用テキスト　かかかきききくくくけけけこここ", price: 100, average_rate: 2.99)
          @neta3 = FactoryBot.create(:neta, :with_user, topic: @topic2, text: "検索用テキスト　検索用Text ABCDEFG HIJKLMN123１２３", price: 200, average_rate: 0)
          @neta4 = FactoryBot.create(:neta, user: @user3, topic: @topic1, text: "検索用Text ABCDEFG HIJKLMN123１２３", price: 300, average_rate: 5)
          @params = {}
          @params[:q] = {}
        end
        it "filters topics that matches keyword by title" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'あああ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1, @topic2])
        end
        it "filters topics that matches keyword by text" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'けけけ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1, @topic2])
        end
        it "filters topics that matches keyword by nickname" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'イタチ'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic2])
        end
        it "filters topics that have neta count equal or more" do
          @params[:q][:netas_count_gteq] = '3'
          get :index, params: @params
          expect(assigns(:topics)).to match_array([@topic1])
        end
        it "returns 0 records that doesn't match keyword" do
          @params[:q][:title_or_text_or_netas_text_or_user_nickname_cont] = 'Text that does not exist in database'
          get :index, params: @params
          expect(assigns(:topics).count).to be 0
        end
        it "returns 0 records that doesn't match neta count" do
          @params[:q][:netas_count_gteq] = '4'
          get :index, params: @params
          expect(assigns(:topics).count).to be 0
        end
      end
    end
  end
  
  describe "GET #new" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
      
      it "returns a 200 status code" do
        get :new
        expect(response).to have_http_status("200")
      end
    end
    context "as a guest" do
      
      it "returns a 302 status code" do
        get :new
        expect(response).to have_http_status("302")
      end
      
      it "redirects to the sign-in page" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  
  describe "POST #create" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
        @attributes = topic_attributes
      end
    
      it "returns a 302 status code" do
        post :create, params: { topic: { title: @attributes[:title], text: @attributes[:text] } }
        expect(response).to have_http_status("302")
      end
      
      it "creates a topic" do
        expect{
          post :create, params: { topic: { title: @attributes[:title], text: @attributes[:text] } }
        }.to change(Topic, :count).by(1)
      end
    end
    context "as a guest" do
      
      it "returns a 302 status code" do
        post :create, params: {}
        expect(response).to have_http_status("302")
      end
      
      it "redirects to the sign-in page" do
        post :create, params: {}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  
  describe "GET #show" do
    before do
      @test_topic = FactoryBot.create(:topic, :with_user)
      @test_netas = create_list(:neta, 3, :with_user, topic: @test_topic)
      @test_comments = create_list(:comment, 3, :with_user, commentable: @test_topic)
    end
    context "as guest" do
      it "populates @topic" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:topic)).to match(@test_topic)
      end
      it "populates @netas" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:netas)).to match(@test_netas)
      end
      it "populates @comments" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:comments)).to match(@test_comments)
      end
      it "renders the :show template" do
        get :show, params: { id: @test_topic.id }
        expect(response).to render_template :show
      end
      it "returns a 200 status code" do
        get :show, params: { id: @test_topic.id }
        expect(response).to have_http_status("200")
      end
    end
    context "as authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      it "populates @topic" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:topic)).to match(@test_topic)
      end
      it "populates @netas" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:netas)).to match(@test_netas)
      end
      it "populates @comments" do
        get :show, params: { id: @test_topic.id }
        expect(assigns(:comments)).to match(@test_comments)
      end
      it "adds pageview" do
        expect{
          get :show, params: { id: @test_topic.id }
        }.to change(Pageview, :count).by(1)
      end
      it "renders the :show template" do
        get :show, params: { id: @test_topic.id }
        expect(response).to render_template :show
      end
      it "returns a 200 status code" do
        get :show, params: { id: @test_topic.id }
        expect(response).to have_http_status("200")
      end
    end
  end
  
  describe "GET #edit" do
    context "as authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      context "not as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, :with_user)
        end
        it "populates @topic" do
          get :show, params: { id: @test_topic.id }
          expect(assigns(:topic)).to match(@test_topic)
        end
        it "returns a 302 status code" do
          get :edit, params: { id: @test_topic.id }
          expect(response).to have_http_status("302")
        end
        it "redirects to topic#show" do
          get :edit, params: { id: @test_topic.id }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context "as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, user: @user)
        end
        it "renders the :show template" do
          get :show, params: { id: @test_topic.id }
          expect(response).to render_template :show
        end
        it "returns a 200 status code" do
          get :show, params: { id: @test_topic.id }
          expect(response).to have_http_status("200")
        end
      end
    end
    context "as a guest" do
      before do
        @test_topic = topic_create
      end
      it "returns a 302 status code" do
        get :edit, params: { id: @test_topic.id }
        expect(response).to have_http_status("302")
      end
      
      it "redirects to user sign-in page" do
        get :edit, params: { id: @test_topic.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  
  describe "PATCH #update" do
    context "as authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      context "not as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, :with_user)
        end
        it "populates @topic" do
          patch :update, params: { id: @test_topic.id }
          expect(assigns(:topic)).to match(@test_topic)
        end
        it "redirects to topic#show" do
          patch :update, params: { id: @test_topic.id }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context "as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, user: @user)
        end
        it "populates @topic" do
          patch :update, params: { id: @test_topic.id }
          expect(assigns(:topic)).to match(@test_topic)
        end
        it "updates topic" do
          expect{
            patch :update, params: { id: @test_topic.id, title: "Title for topic controller update test", text: "Text for topic controller update test" }
          }.to change(Topic, :count).by(0)
        end
        it "redirects to topic#show when update returns false" do
          allow_any_instance_of(Topic).to receive(:update!).and_return(false)
          patch :update, params: { id: @test_topic.id }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
    end
    context "as a guest" do
      before do
        @test_topic = topic_create
      end
      it "returns a 302 status code" do
        patch :update, params: { id: @test_topic.id }
        expect(response).to have_http_status("302")
      end
      it "redirects to user sign-in page" do
        patch :update, params: { id: @test_topic.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "as authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      context "not as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, :with_user)
        end
        it "populates @topic" do
          delete :destroy, params: { id: @test_topic.id }
          expect(assigns(:topic)).to match(@test_topic)
        end
        it "redirects to topic#show" do
          delete :destroy, params: { id: @test_topic.id }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context "as a topic owner" do
        before do
          @test_topic = FactoryBot.create(:topic, user: @user)
        end
        it "populates @topic" do
          delete :destroy, params: { id: @test_topic.id }
          expect(assigns(:topic)).to match(@test_topic)
        end
        context "if topic is deleteable" do
          before do
            allow_any_instance_of(Topic).to receive(:is_deleteable).and_return(true)
          end
          it "deletes topic" do
            expect{ 
              delete :destroy, params: { id: @test_topic.id } 
            }.to change(Topic, :count).by(-1)
          end
          it "redirects to topic#show when update returns false" do
            allow_any_instance_of(Topic).to receive(:destroy!).and_return(false)
            delete :destroy, params: { id: @test_topic.id }
            expect(response).to redirect_to topic_path(@test_topic.id)
          end
        end
        context "if topic is not deleteable" do
          before do
            allow_any_instance_of(Topic).to receive(:is_deleteable).and_return(false)
          end
          it "redirects to topic#show" do
            delete :destroy, params: { id: @test_topic.id }
            expect(response).to redirect_to topic_path(@test_topic.id)
          end
        end
      end
    end
    context "as a guest" do
      before do
        @test_topic = topic_create
      end
      it "returns a 302 status code" do
        patch :update, params: { id: @test_topic.id }
        expect(response).to have_http_status("302")
      end
      it "redirects to user sign-in page" do
        patch :update, params: { id: @test_topic.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
