require 'rails_helper'
require 'support/omniauth_mock'

RSpec.describe "SignUps", type: :request do
  subject { page }

  describe "new user registration" do
  	before { visit new_user_registration_path }
  	
  	describe "with invalid information" do

  		it "should not create a user" do
	  		fill_in "Username",              with: " "
	  		fill_in "Email",                 with: " "
	  		fill_in "Password",              with: " "
	  		fill_in "Password confirmation", with: " "
	  		expect { click_button "Sign up" }.not_to change(User, :count)
  		end
  	end

    describe "with valid information" do
      
      it "should create a user" do
        fill_in "Username",              with: "username"
        fill_in "Email",                 with: "email@email.com"
        fill_in "Password",              with: "password"
        fill_in "Password confirmation", with: "password"
        expect { click_button "Sign up" }.to change(User, :count).by(1)
      end
    end

    describe  "after successful registraion" do
      before do
        fill_in "Username",              with: "username"
        fill_in "Email",                 with: "email@email.com"
        fill_in "Password",              with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "Sign up"
      end

      it "should redirect to root" do
        expect(page.current_path).to eq(root_path)
      end

      it { should have_selector "div.alert-success", visible: false }
    end

    describe "with Instagram", omniauth: :mock do
      before do
        omniauth_test_mode!
        mock_omniauth_instagram
      end

      after { omniauth_reset :instagram }

      let(:to_instagram) { "Sign in with Instagram" }

      it "should create a new user" do
        VCR.use_cassette "sign_ups_spec_with_instagram" do
          expect { click_link to_instagram }.to change(User, :count)
        end
      end

      it "should create a new authentication" do
        VCR.use_cassette "sign_ups_spec_with_instagram" do
          expect { click_link to_instagram }.to change(Authentication, :count)
        end
      end

      it "should redirect to root" do
        VCR.use_cassette "sign_ups_spec_with_instagram" do
          click_link to_instagram
          expect(page.current_path).to eq(root_path)
        end
      end
    end
  end
end
