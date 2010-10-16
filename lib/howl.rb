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
  end

  class Template

  end

  class Page < Template

  end

  class Post < Template

  end
end
