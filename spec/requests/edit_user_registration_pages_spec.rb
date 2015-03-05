require 'rails_helper'
require 'support/omniauth_mock'

RSpec.describe "Edit User Registration Page", type: :request do
  
  subject { page }

  describe  "Accessing the edit registration page" do
    
    describe "without logging in" do
      before { visit edit_user_registration_path }

      it "should redirect to sign in" do
        expect(page.current_path).to eq(new_user_session_path)
      end
    end
  end

  describe "Changing password after omniauth registration" do
    before do
      mock_omniauth_instagram
      visit new_user_registration_path
      VCR.use_cassette "sign_ups_spec_with_instagram" do
        click_link "Sign in with Instagram"
      end
      click_link "Account"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      VCR.use_cassette "change_password_after_omniauth_registration" do
        click_button "Update"
      end
    end

    it "should be sucessful" do
      expect(page).to have_selector("div.alert-success")
    end

    it "should update password without a current password" do
      expect(User.first.encrypted_password).not_to be_nil
    end

    it "should require current password for further changes" do
      click_link "Account"
      fill_in "Email", with: "new@email.com"
      click_button "Update"
      expect(page).not_to have_selector("div.alert-success")
      expect(page).to have_selector("div#error_explanation")
    end
  end
end
