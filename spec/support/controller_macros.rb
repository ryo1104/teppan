module ControllerMacros
  def login_user
    before(:each) do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      @request.env['devise.mapping'] = Devise.mappings[:users]
      @user = FactoryBot.create(:user)
      # @user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user
    end
  end
end
