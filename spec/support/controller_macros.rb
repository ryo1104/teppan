module ControllerMacros
  def login_user
    before(:each) do
      # controller.stub(:authenticate_user!).and_return true
      allow(controller).to receive(:authenticate_user!).and_return(true)
      @request.env["devise.mapping"] = Devise.mappings[:users]
      # puts Devise.mappings[:user].inspect
      user = FactoryBot.create(:user)
      #@user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      #puts @user.inspect
      puts "sign_in : "
      puts sign_in(user)
      
      get user_path(user)
    end
  end
end