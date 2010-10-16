require 'yaml'
require 'mustache'
require 'hashie'
require 'pathname'
require 'fileutils'
require 'time'

def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

$:.unshift File.dirname(__FILE__)
require 'howl/template'
require 'howl/site'
require 'howl/plugin'
require 'howl/converter'
require_all 'howl/converters'

class String
  def drop(num)
    self.dup.split(//).drop(num).join
  end
end

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
