require 'teststrap'
include Howl

context "Integration Site" do
  setup { Site.new(File.join(File.dirname(__FILE__), "integration_site")) }

  should "generate successfully" do
    topic.write_to_disk
  end
end
