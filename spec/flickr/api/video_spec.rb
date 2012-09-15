require "spec_helper"

describe Flickr::Video, :vcr do
  describe "flickr.photos.search" do
    # before(:all) { @videos = make_request("flickr.photos.search", Flickr::Video) }

    it "passes the media type" do
      pending "A video needs to be uploaded to Flickr for this"
      @videos.should_not be_empty
      @videos.each { |video| video.should be_a(Flickr::Video) }
    end
  end
end