require 'yaml'
require 'rdiscount'
require 'mustache'
require 'pathname'
require 'fileutils'

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

    def templates
      @templates ||= Hash[Dir[root + "templates/*"].map { |path| 
        [Pathname.new(path).relative_path_from(path "templates").to_s, 
         Template.new(path, self)] 
      }]
    end

    def write_to_disk
      FileUtils.rm_r(path "site") if File.exist?(path "site")
      FileUtils.makedirs(path "site")
      pages.each do |page|
        page.output_path.open("w") do |fh|
          fh.write page.render
        end
      end
    end
  end

  class Template
    attr_accessor :data, :content, :site

    def initialize(path, site)
      @site = site
      @path = Pathname.new(path)
      @extension = @path.extname
      load_file
    end

    def ==(other)
      self.path == other.path && self.class == other.class
    end

    def render(render_data = {})
      render_data.merge!(@data)
      rendered = Mustache.render(@content, render_data)
      template = render_data.delete("template")
      if template
        rendered = @site.templates[template + @extension].render(render_data.merge("content" => rendered))
      end

      rendered
    end
    private

    def load_file
      content = @path.read
      data, content = content.split("\n\n", 2)

      if test_for_yaml(data)
        @data = YAML.load(data)
        @content = content
      else
        @data = {}
        @content = "#{data}\n\n#{content}".strip
      end
    end

    def test_for_yaml(data)
      begin
        data = YAML.load(data)
        data.is_a?(Hash)
      rescue ArgumentError
        false
      end
    end
  end

  class Page < Template
    attr_accessor :path

    def output_path
      site.path("site") + path.relative_path_from(site.path "pages")
    end
  end

  class Post < Template
  end
end
