require 'yaml'
require 'rdiscount'
require 'mustache'
require 'hashie'
require 'pathname'
require 'fileutils'
require 'time'

$:.unshift File.dirname(__FILE__)
require 'howl/template'
require 'howl/site'
require 'howl/plugin'
require 'howl/converter'

module Howl
  class View < Hashie::Mash
  end

  class Page < Template
    def output_path
      site.path("site") + path.relative_path_from(site.path "pages").dirname + output_filename
    end
  end

  class Post < Template
    include Comparable

    def date
      view.date? ? Time.parse(view.date) : File.mtime(path)
    end

    def output_path
      site.path("site/posts") + date.strftime("%Y/%m/%d") + output_filename
    end

    def <=>(other)
      self.date <=> other.date
    end
  end
end
