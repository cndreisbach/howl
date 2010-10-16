require 'teststrap'
include Howl

context "Site" do
  setup { Site.new(fixture_path) }
  
  should("find all pages") {
    topic.pages == Dir[fixture_path("pages/*")].map { |path| Page.new(path, topic) }
  }
end

context "Page" do
  setup { @site = Site.new(fixture_path) }

  context "simple.html" do
    setup { Page.new(fixture_path("pages/simple.html"), @site) }

    asserts(:data).equals({"title" => "This is a simple page"})
    asserts("#content") { topic.content.strip }.equals "<h1>{{title}}</h1>"
  end

  context "no_yaml.html" do
    setup { Page.new(fixture_path("pages/no_yaml.html"), @site) }

    asserts(:data).equals({})
    asserts("#content") { topic.content.strip }.equals "This page has no YAML front-matter."
  end

  context "has_template.html" do
    setup { Page.new(fixture_path("pages/has_template.html"), @site) }
  end
end
