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
  end

  class Template
    attr_accessor :data, :content

    def initialize(path, site)
      @site = site
      @path = Pathname.new(path)
      @extension = @path.extname
      load_file
    end

    def ==(other)
      self.path == other.path && self.class == other.class
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
      root + "site" + path.relative_path_from(site.root + "pages")
    end
  end

  class Post < Template
  end
end
