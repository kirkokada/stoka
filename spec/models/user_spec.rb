require 'rails_helper'

RSpec.describe User, type: :model do
	let!(:user) { User.new(email: "example@email.com", 
		                     password: "password",
		                     password_confirmation: "password",
		                     username: "username") }

	subject { user }

	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :email }
	it { should respond_to :username }
	it { should respond_to :authentications }

	it { should be_valid }

	describe "when username" do
		
		describe "is nil" do
			it "should not be valid" do
				user.username = nil
				expect(user).not_to be_valid
			end
		end

		describe "is blank" do
			it "should not be valid" do
				user.username = ""
				expect(user).not_to be_valid
			end
		end

		describe "contains non-word characters" do
			it "should not be valid" do
				%w[usern@me user&name username!].each do |n|
					user.username = n
					expect(user).not_to be_valid
				end
			end
		end

		describe "already exists" do
			it "should not be valid" do
				dup_user = user.dup
				dup_user.username.upcase!
				expect { dup_user.save }.to change(User, :count)
				expect(user).not_to be_valid
			end
		end
	end

	describe "when email" do
		
		describe "is nil" do
			it "should not be valid" do
				user.email = nil
				expect(user).to be_valid
			end
		end

		describe "is blank" do
			it "should be valid" do
				user.email = ""
				expect(user).to be_valid
			end
		end

		describe "already exists" do
			it "should not be valid" do
				dup_user = user.dup
				dup_user.email.upcase!
				expect { dup_user.save }.to change(User, :count)
				expect(user).not_to be_valid
			end
		end
	end

	describe "when password" do
		
		describe "is nil" do
			
			it "should not be valid" do
				user.password = nil
				expect(user).not_to be_valid
			end
		end

		describe "is blank" do
			
			it "should not be valid" do
				user.password = " "
				expect(user).not_to be_valid
			end
		end
	end

	describe "authentications" do
		
		before do 
			user.save
			user.authentications.create(provider: "instagram", uid: "1") 
		end

		describe "dependent destroy" do
			
			it "should destroy the authentication when the user is deleted" do
				expect { user.destroy }.to change(Authentication, :count)
			end
		end
	end
end
