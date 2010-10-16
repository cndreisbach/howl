require 'teststrap'
include Howl

context "Site" do
  setup { @site = Site.new(fixture_path) }
  
  should("find all pages") {
    topic.pages == Dir[fixture_path("pages/**/*.*")].map { |path| Page.new(path, topic) }
  }

  should("write out all pages") {
    topic.write_to_disk
    topic.pages.map { |page|
      File.exist?(page.output_path)
    }.all?
  }

  should("write out all posts") {
    topic.write_to_disk
    topic.posts.map { |post|
      Dir[topic.path("site/posts") + "**/*.*"].map { |path|
        File.basename(path, File.extname(path)) 
      }.include?(post.path.basename(post.extension).to_s)
    }.all?
  }

  context "Page" do
    context "simple.html" do
      setup { Page.new(fixture_path("pages/simple.html"), @site) }

      asserts("#content") { topic.content.strip }.equals "<h1>{{title}}</h1>"
      asserts("#view is correct") {
        topic.view == View.new(:site => topic.site, :title => "This is a simple page")
      }
      asserts("#rendered") { topic.render.strip }.equals "<h1>This is a simple page</h1>"

      should("be able to find its output path") {
        topic.output_path == (topic.site.path "site/simple.html")
      }
    end

    context "no_yaml.html" do
      setup { Page.new(fixture_path("pages/no_yaml.html"), @site) }

      asserts("#content") { topic.content.strip }.equals "This page has no YAML front-matter."
      asserts("#view is correct") {
        topic.view == View.new(:site => topic.site)
      }
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

  context "Post" do
    setup { Post.new(fixture_path("posts/first_post.html"), @site) }

    asserts("date is equal to date from front matter") { 
      topic.date == Time.parse("2010/09/04") 
    }

    asserts(:output_path).equals {
      topic.site.path("site/posts/2010/09/04") + "first_post.html"
    }

    context "without a date" do
      setup { Post.new(fixture_path("posts/no_date.html"), @site) }

      asserts("date is equal to file's mtime") { topic.date == File.mtime(topic.path) }
    end
  end

  context "A Post in Markdown" do
    setup { Post.new(fixture_path("posts/markdown_post.md"), @site) }

    should "convert to HTML" do
      topic.render == RDiscount.new(topic.content).to_html
    end
  end
end

