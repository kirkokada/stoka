require 'rails_helper'
require 'support/omniauth_mock'

RSpec.describe "Sign in", type: :request do
  let(:username) { ENV["INSTAGRAM_USERNAME"] }
  let(:email)    { "user@email.com" }
  let(:password) { "password" }
  let!(:user)     { FactoryGirl.create :user, username: username,
                                             email: email,
                                             password: password, 
                                             password_confirmation: password }

  before { visit new_user_session_path }


  subject { page }

  describe "with invalid" do

    describe "username" do
      before do
        fill_in "Login", with: "incorrect"
        fill_in "Password", with: password
        click_button "Sign in"
      end

      it "should redirect to sign in page" do
        expect(page.current_path).to eq(new_user_session_path)
      end

      it { should have_selector "div.alert-danger" }
    end

    describe "email" do
      before do
        fill_in "Login", with: "incorrect@email.com"
        fill_in "Password", with: password
        click_button "Sign in"
      end

      it "should redirect to sign in page" do
        expect(page.current_path).to eq(new_user_session_path)
      end

      it { should have_selector "div.alert-danger" }
    end

    describe "password" do
      before do
        fill_in "Login", with: username
        fill_in "Password", with: "invalid"
        click_button "Sign in"
      end

      it "should redirect to sign in page" do
        expect(page.current_path).to eq(new_user_session_path)
      end

      it { should have_selector "div.alert-danger" }
    end
  end

  describe "with valid" do
    
    describe "username and password" do
      before do
        fill_in "Login",    with: username
        fill_in "Password", with: password
        click_button "Sign in"
      end

      it "should redirect to root" do
        expect(page.current_path).to eq(root_path)
      end

      it { should have_selector "div.alert-success" }
    end

    describe "email and password" do
      before do
        fill_in "Login",    with: email
        fill_in "Password", with: password
        click_button "Sign in"
      end

      it "should redirect to root" do
        expect(page.current_path).to eq(root_path)
      end

      it { should have_selector "div.alert-success" }
    end
  end

  describe "with Instagram", omniauth: :mock do
    let(:to_instagram) { "Sign in with Instagram" }
    let!(:authentication) { user.authentications.create(provider: "instagram", 
                                                        uid: ENV["INSTAGRAM_UID"],
                                                        token: ENV["INSTAGRAM_ACCESS_TOKEN"]) }

    before do
      omniauth_test_mode!
      mock_omniauth_instagram
      visit new_user_session_path
    end

    it "should not create another authentication" do
      VCR.use_cassette "sign_in_spec_with_instagram" do
        expect { click_link to_instagram }.not_to change(Authentication, :count)
      end
    end

    it "should be successful" do
      VCR.use_cassette "sign_in_spec_with_instagram" do
        click_link to_instagram
        expect(page.current_path).to eq(root_path)
        expect(page).to have_selector "div.alert-success"
      end
    end
  end
end
