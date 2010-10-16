require 'yaml'
require 'rdiscount'
require 'mustache'
require 'hashie'
require 'pathname'
require 'fileutils'
require 'time'

$:.unshift File.dirname(__FILE__)

module Howl
  class Site
    attr_accessor :root

    def initialize(root)
      @root = Pathname.new(root)
    end

    def path(path)
      root + path
    end

    def pages
      @pages ||= Dir[path "pages/*"].map { |path| Page.new(path, self) }
    end

    def posts
      @posts ||= Dir[path "posts/*"].map { |path| Post.new(path, self) }.sort
    end

    def templates
      @templates ||= Hash[Dir[root + "templates/*"].map { |path| 
        [Pathname.new(path).relative_path_from(path "templates").to_s, 
         Template.new(path, self)] 
      }]
    end

    def write_to_disk
      FileUtils.rm_r(path "site") if File.exist?(path "site")
      #raise (pages + posts).map(&:class).inspect
      (pages + posts).each do |page|
        FileUtils.makedirs(page.output_path.dirname)
        page.output_path.open("w") do |fh|
          fh.write page.render
        end
      end
    end
  end

  class View < Hashie::Mash
  end

  class Template
    attr_accessor :view, :content, :site, :path

    def initialize(path, site)
      @site = site
      @path = Pathname.new(path)
      @extension = @path.extname
      load_file
    end

    def ==(other)
      self.path == other.path && self.class == other.class
    end

    def render(render_view = {})
      render_view.merge!(@view)
      rendered = Mustache.render(@content, render_view)
      template = render_view.delete("template")
      if template
        begin
          rendered = @site.templates[template + @extension].render(render_view.merge("content" => rendered))
        rescue NoMethodError => ex
          puts "Warning: Template #{template + @extension} does not exist in file #{path}"
          rendered
        end
      end

      rendered
    end

    private

    def load_file
      content = @path.read
      view, content = content.split("\n\n", 2)

      if test_for_yaml(view)
        @content = content
        view = YAML.load(view)
      else
        @content = "#{view}\n\n#{content}".strip
        view = {}
      end

      @view = View.new(view.merge(:site => site))
    end

    def test_for_yaml(view)
      begin
        view = YAML.load(view)
        view.is_a?(Hash)
      rescue ArgumentError
        false
      end
    end
  end

  class Page < Template
    def output_path
      site.path("site") + path.relative_path_from(site.path "pages")
    end
  end

  class Post < Template
    include Comparable

    def date
      view.date? ? Time.parse(view.date) : File.mtime(path)
    end

    def output_path
      site.path("site/posts") + date.strftime("%Y/%m/%d") + path.basename
    end

    def <=>(other)
      self.date <=> other.date
    end
  end
end
