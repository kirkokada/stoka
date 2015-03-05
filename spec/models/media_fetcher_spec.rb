require 'rails_helper'

RSpec.describe MediaFetcher, type: :model do
		let(:mediafetcher) { MediaFetcher.new(ig_username: "therock") }

	subject { mediafetcher }

	describe "ig profile" do
		
		it "should return profile info if username exists" do
			VCR.use_cassette "mediafetcher_spec_ig_profile:username_exists" do
				ig_profile = mediafetcher.ig_profile
				expect(ig_profile).not_to be_empty
			end
		end

		describe "when no matching user is found" do
			before { mediafetcher.ig_username = "nobodyhasthisname999" }

			it "should not be valid" do
				VCR.use_cassette "mediafetcher_spec_ig_profile:username_not_found" do
					expect(mediafetcher).not_to be_valid
				end
			end
		end
	end

	describe "ig recent media" do
		let(:recent_media) { mediafetcher.ig_recent_media }

		it 'should return results with location data' do
			VCR.use_cassette "mediafetcher_spec_ig_recent_media" do
				recent_media.each do |media|
					expect(media['location']).not_to be_nil
				end
			end
		end
	end
end
