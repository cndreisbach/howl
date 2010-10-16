require 'teststrap'
include Howl

context "Site" do
  setup { Site.new(fixture_path) }
  
  should("find all pages") {
    topic.pages == Dir[fixture_path("pages/*")].map { |path| Page.new(path, topic) }
  }

  should("write out all pages") {
    topic.write_to_disk
    topic.pages.map { |page|
      File.exist?(page.output_path)
    }.all?
  }
end

context "Page" do
  setup { @site = Site.new(fixture_path) }

  context "simple.html" do
    setup { Page.new(fixture_path("pages/simple.html"), @site) }

    asserts(:data).equals({"title" => "This is a simple page"})
    asserts("#content") { topic.content.strip }.equals "<h1>{{title}}</h1>"
    asserts("#rendered") { topic.render.strip }.equals "<h1>This is a simple page</h1>"

    should("be able to find its output path") {
      topic.output_path == (topic.site.path "site/simple.html")
    }
  end

  context "no_yaml.html" do
    setup { Page.new(fixture_path("pages/no_yaml.html"), @site) }

    asserts(:data).equals({})
    asserts("#content") { topic.content.strip }.equals "This page has no YAML front-matter."
    asserts("#rendered") { topic.render.strip }.equals "This page has no YAML front-matter."
  end

  context "has_template.html" do
    setup { Page.new(fixture_path("pages/has_template.html"), @site) }

    asserts("#rendered") { topic.render.clean }.equals %Q[
<html>
<head><title>This page has a template</title></head>
<h1>This page has a template</h1>
<div>
  Hello world!
</div>
</html>
    ].clean
  end
end
