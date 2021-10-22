require 'rails_helper'

RSpec.describe TopicsController, type: :request do
  let(:user_create)           { create(:user) }
  let(:topic_create)          { create(:topic, :with_user) }
  let(:topic_list_create)     { create_list(:topic, 5, :with_user) }
  let(:topic_attributes)      { attributes_for(:topic) }
  let(:neta_create)           { create(:neta, :with_user, topic: topic_create) }
  let(:hashtag_list_create)   { create_list(:hashtag, 15, :with_random_hit_count, :with_random_neta_count) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'returns a 200 status code' do
        get topics_url
        expect(response).to have_http_status('200')
      end
      it 'populates @topic_cards ordered by created_at DESC' do
        topics = topic_list_create
        get topics_url
        expect(assigns(:topic_cards)).to match(topics.sort { |a, b| b.created_at <=> a.created_at })
      end
      it 'populates @hashtag_ranking' do
        hashtag_list_create
        get topics_url
        expect(assigns(:hashtag_ranking)).not_to be_empty
      end
      context 'searches' do
        before do
          @user1 = create(:user, nickname: 'はたけ　カカシ')
          @user2 = create(:user, nickname: 'うちは　イタチ')
          @user3 = create(:user, nickname: 'ウズマキ　ナルト')
          @topic1 = create(:topic, user: @user1, title: '検索用タイトル１', content: '検索用テキスト　あああいいいうううえええおおお')
          @topic2 = create(:topic, user: @user2, title: '検索用タイトル２けけけ', content: '検索用テキスト　あああかかかさささたたたななな')
          @neta1 = create(:neta, :with_user, topic: @topic1, title: '検索用テキスト　あああいいいうううえええおおお', valuecontent: 'aaa', price: 50, average_rate: 3.01)
          @neta2 = create(:neta, :with_user, topic: @topic1, title: '検索用テキスト　かかかきききくくくけけけこここ', valuecontent: 'aaa', price: 100, average_rate: 2.99)
          @neta3 = create(:neta, :with_user, topic: @topic2, title: '検索用テキスト　検索用Text ABCDEFG H12１２', valuecontent: 'aaa', price: 200, average_rate: 0)
          @neta4 = create(:neta, user: @user3, topic: @topic1, title: '検索用Text ABCDEFG HIJKLMN123１２３', valuecontent: 'aaa', price: 300, average_rate: 5)
          @params = { q: {} }
        end
        it 'topics containing keyword in title' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'タイトル'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic1, @topic2])
        end
        it 'topics with netas containing keyword in neta title' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'けけけ'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic1, @topic2])
        end
        it 'topics containing keyword in nickname' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'イタチ'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic2])
        end
        it '0 records when no topics, netas, or users contain the keyword' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'Text that does not exist in database'
          get topics_url, params: @params
          expect(assigns(:topic_cards).count).to be 0
        end
      end
    end
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'returns a 200 status code' do
        get topics_url
        expect(response).to have_http_status('200')
      end
      it 'populates @topics_card ordered by created_at DESC' do
        topics = topic_list_create
        get topics_url
        expect(assigns(:topic_cards)).to match(topics.sort { |a, b| b.created_at <=> a.created_at })
      end
      it 'populates @hashtag_ranking' do
        hashtag_list_create
        get topics_url
        expect(assigns(:hashtag_ranking)).not_to be_empty
      end
      context 'searches' do
        before do
          @user1 = create(:user, nickname: 'はたけ　カカシ')
          @user2 = create(:user, nickname: 'うちは　イタチ')
          @user3 = create(:user, nickname: 'ウズマキ　ナルト')
          @topic1 = create(:topic, user: @user1, title: '検索用タイトル１', content: '検索用テキスト　あああいいいうううえええおおお')
          @topic2 = create(:topic, user: @user2, title: '検索用タイトル２けけけ', content: '検索用テキスト　あああかかかさささたたたななな')
          @neta1 = create(:neta, :with_user, topic: @topic1, title: '検索用テキスト　あああいいいうううえええおおお', valuecontent: 'aaa', price: 50, average_rate: 3.01)
          @neta2 = create(:neta, :with_user, topic: @topic1, title: '検索用テキスト　かかかきききくくくけけけこここ', valuecontent: 'aaa', price: 100, average_rate: 2.99)
          @neta3 = create(:neta, :with_user, topic: @topic2, title: '検索用テキスト　検索用Text ABCDEFG H12１２', valuecontent: 'aaa', price: 200, average_rate: 0)
          @neta4 = create(:neta, user: @user3, topic: @topic1, title: '検索用Text ABCDEFG HIJKLMN123１２３', valuecontent: 'aaa', price: 300, average_rate: 5)
          @params = {}
          @params[:q] = {}
        end
        it 'topics containing keyword in title' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'タイトル'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic1, @topic2])
        end
        it 'topics with netas containing keyword in neta title' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'けけけ'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic1, @topic2])
        end
        it 'topics containing keyword in nickname' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'イタチ'
          get topics_url, params: @params
          expect(assigns(:topic_cards)).to match_array([@topic2])
        end
        it '0 records when no topics, netas, or users contain the keyword' do
          @params[:q][:title_or_netas_title_or_user_nickname_cont] = 'Text that does not exist in database'
          get topics_url, params: @params
          expect(assigns(:topic_cards).count).to be 0
        end
      end
    end
  end

  describe 'GET #new' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'returns a 200 status code' do
        get new_topic_url
        expect(response).to have_http_status('200')
      end
    end
    context 'as a guest' do
      it 'returns a 302 status code' do
        get new_topic_url
        expect(response).to have_http_status('302')
      end
      it 'redirects to the sign-in page' do
        get new_topic_url
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @attributes = topic_attributes
      end
      it 'returns a 302 status code' do
        post topics_url, params: { topic: { title: @attributes[:title], content: @attributes[:content] } }
        expect(response).to have_http_status('302')
      end
      it 'creates a topic' do
        expect do
          post topics_url, params: { topic: { title: @attributes[:title], content: @attributes[:content] } }
        end.
          to change(Topic, :count).by(1)
      end
    end
    context 'as a guest' do
      it 'returns a 302 status code' do
        post topics_url, params: {}
        expect(response).to have_http_status('302')
      end
      it 'redirects to the sign-in page' do
        post topics_url, params: {}
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #show' do
    before do
      @test_topic = create(:topic, :with_user, title: 'テストトピックタイトル')
      @test_netas = create_list(:neta, 3, :with_user, topic: @test_topic)
      @test_comments = create_list(:comment, 3, :with_user, commentable: @test_topic)
    end
    subject { get topic_url @test_topic.id }
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'displays the topic' do
        subject
        expect(response.body).to include 'テストトピックタイトル'
      end
      it 'displays netas associated with the topic' do
        subject
        expect(response.body).to include 'ネタテスト　タイトル'
      end
      it 'displays comments associated with the topic' do
        subject
        expect(response.body).to include 'テストコメント'
      end
      it 'adds pageview' do
        expect do
          subject
        end.
          to change(Pageview, :count).by(1)
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
      context 'when private flag is true while not the owner of topic' do
        before do
          @private_topic = create(:topic, :with_user, title: '非公開トピックタイトル', private_flag: true)
        end
        subject { get topic_url @private_topic.id }
        it 'displays block message that topic is private' do
          subject
          expect(response.body).to include 'このトピックは非公開に設定されています。'
        end
        it 'returns a 200 status code' do
          subject
          expect(response).to have_http_status('200')
        end
      end
    end
    context 'as guest' do
      it 'displays the topic' do
        get topic_url @test_topic.id
        expect(response.body).to include 'テストトピックタイトル'
      end
      it 'displays netas associated with the topic' do
        get topic_url @test_topic.id
        expect(response.body).to include 'ネタテスト　タイトル'
      end
      it 'displays comments associated with the topic' do
        get topic_url @test_topic.id
        expect(response.body).to include 'テストコメント'
      end
      it 'returns a 200 status code' do
        get topic_url @test_topic.id
        expect(response).to have_http_status('200')
      end
    end
  end

  describe 'GET #edit' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'but not topic owner' do
        before do
          @test_topic = topic_create
        end
        it 'returns a 302 status code' do
          get edit_topic_url @test_topic.id
          expect(response).to have_http_status('302')
        end
        it 'redirects to topic#show' do
          get edit_topic_url @test_topic.id
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context 'and topic owner' do
        before do
          @test_topic = create(:topic, user: @user, title: 'テストトピックタイトル')
        end
        it 'displays the topic' do
          get edit_topic_url @test_topic.id
          expect(response.body).to include 'テストトピックタイトル'
        end
        it 'returns a 200 status code' do
          get edit_topic_url @test_topic.id
          expect(response).to have_http_status('200')
        end
      end
    end
    context 'as a guest' do
      before do
        @test_topic = topic_create
      end
      it 'returns a 302 status code' do
        get edit_topic_url @test_topic.id
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        get edit_topic_url @test_topic.id
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @test_topic = create(:topic, user: @user, title: 'テストトピックタイトル')
      end
      context 'but not topic owner' do
        it 'redirects to topic#show' do
          patch topic_url @test_topic, params: { topic: { title: '変更後テストトピックタイトル' } }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context 'and topic owner' do
        it 'updates topic' do
          expect do
            patch topic_url @test_topic, params: { topic: { title: '変更後テストトピックタイトル' } }
          end.
            to change { Topic.find(@test_topic.id).title }.from('テストトピックタイトル').to('変更後テストトピックタイトル')
        end
        it 'redirects to topic#show when update succeeds' do
          patch topic_url @test_topic, params: { topic: { title: '変更後テストトピックタイトル' } }
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
        it 'displays topic#edit when update fails' do
          allow_any_instance_of(Topic).to receive(:update).and_return(false)
          patch topic_url @test_topic, params: { topic: { title: 'Title for topic controller update test', text: 'Text for topic controller update test' } }
          expect(response.body).to include 'テストトピックタイトル'
        end
      end
    end
    context 'as a guest' do
      before do
        @test_topic = topic_create
      end
      it 'returns a 302 status code' do
        patch topic_url @test_topic, params: { topic: { title: '変更後テストトピックタイトル' } }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        patch topic_url @test_topic, params: { topic: { title: '変更後テストトピックタイトル' } }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'not as a topic owner' do
        before do
          @test_topic = create(:topic, :with_user)
        end
        it 'does not delete the topic' do
          expect do
            delete topic_url @test_topic
          end.
            to change(Topic, :count).by(0)
        end
        it 'redirects to topic#show' do
          delete topic_url @test_topic
          expect(response).to redirect_to topic_path(@test_topic.id)
        end
      end
      context 'as a topic owner' do
        before do
          @test_topic = create(:topic, user: @user, title: 'テストトピックタイトル')
        end
        context 'if topic is deleteable' do
          before do
            allow_any_instance_of(Topic).to receive(:deleteable).and_return(true)
          end
          it 'deletes the topic' do
            expect do
              delete topic_url @test_topic
            end.
              to change(Topic, :count).by(-1)
          end
          it 'displays topic#edit when destroy fails', type: :doing do
            allow_any_instance_of(Topic).to receive(:destroy).and_return(false)
            delete topic_url @test_topic
            expect(response.body).to include 'テストトピックタイトル'
          end
        end
        context 'if topic is not deleteable' do
          before do
            allow_any_instance_of(Topic).to receive(:deleteable).and_return(false)
          end
          it 'does not delete the topic' do
            expect do
              delete topic_url @test_topic
            end.
              to change(Topic, :count).by(0)
          end
          it 'redirects to topic#show' do
            delete topic_url @test_topic
            expect(response).to redirect_to topic_path(@test_topic.id)
          end
        end
      end
    end
    context 'as a guest' do
      before do
        @test_topic = topic_create
      end
      it 'returns a 302 status code' do
        delete topic_url @test_topic
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        delete topic_url @test_topic
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
