require 'yaml'
require 'mustache'
require 'pathname'
require 'fileutils'
require 'time'

$:.unshift File.dirname(__FILE__)

def require_all(path)
  Dir[File.join(File.dirname(__FILE__), path, '*.rb')].each do |f|
    require f
  end
end

%w(core_ext plugin converter site template page post view).each do |file|
  require "howl/#{file}"
end

require_all "howl/converters"
