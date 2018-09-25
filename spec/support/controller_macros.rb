module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      admin = FactoryBot.create(:admin)
      sign_in admin
      api_authorize(admin.auth_token)
    end
  end

  def login_member
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
      api_authorize(admin.auth_token)
    end
  end
end