require 'rails_helper'
require 'support/omniauth_mock'
require 'support/sign_in_helper'

RSpec.describe "Edit User Registration Page", type: :request do
  let(:user) { FactoryGirl.create(:user) }
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

  describe "elements" do

    before do
      sign_in user
      visit edit_user_registration_path 
    end
    
    it { should have_selector "input#user_email" }
    it { should_not have_selector "input#user_username" }
    it { should have_selector "input#user_password" }
    it { should have_selector "input#user_password_confirmation" }
    it { should have_selector "span.social_media_authentication" }

  end

  describe "instagram account link" do
    before do
      sign_in user
      visit edit_user_registration_path 
    end

    it "should link user's instagram account" do
      VCR.use_cassette "instagram_authentication" do
        expect { click_link "Link your Instagram account" }.to change(user.authentications, :count)
      end
    end

    it "should unlink a user's instagram account" do
      VCR.use_cassette "instagram_authentication" do 
        click_link "Link your Instagram account" 
      end
      visit edit_user_registration_path
      expect do 
        click_link "Unlink your Instagram account" 
      end.to change(user.authentications, :count).by(-1)
    end
  end
end
