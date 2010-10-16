require 'teststrap'
include Howl

context "Site" do
  setup { Site.new(fixture_path) }
end

