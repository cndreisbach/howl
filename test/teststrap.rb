require 'rubygems'
require 'riot'
require 'nokogiri'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'howl'

def fixture_path(path = ".")
  Pathname.new(File.dirname(__FILE__)) + 'fixtures' + path
end

class String
  def clean
    self.strip.gsub(/\n+/, "\n")
  end
end

class Mustache
  def self.raise_on_context_miss? 
    true
  end
end

Riot.verbose
