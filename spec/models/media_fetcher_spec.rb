require 'rails_helper'

RSpec.describe MediaFetcher, type: :model do
	before do
		@mediafetcher = MediaFetcher.new(ig_username: "therock")
	end

	subject { @mediafetcher }

	describe "ig profile" do
		
		it "should return profile info if username exists" do
			ig_profile = @mediafetcher.ig_profile
			expect(ig_profile).not_to be_empty
		end

		describe "when no matching user is found" do
			before { @mediafetcher.ig_username = "nobodyhasthisname999" }

			it { should_not be_valid }
		end
	end

	describe "ig recent media" do
		before { @recent_media = @mediafetcher.ig_recent_media }

		it 'should return results with location data' do
			@recent_media.each do |media|
				expect(media['location']).not_to be_nil
			end
		end
	end
end
