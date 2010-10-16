module Howl
  class Converter < Plugin
    def self.converts(hash = nil)
      @converts ||= {}
      if hash
        @converts.merge!(hash)
      else
        @converts
      end
    end

    def self.matches?(ext)
      @converts.keys.any? do |matcher|
        matcher.match(ext)
      end
    end

    attr_accessor :extension

    def initialize(template)
      @template = template
      ext_regexp = self.class.converts.find { |conversion| conversion[0].match(@template.extension) }
      @extension = @template.extension.gsub(ext_regexp[0], ext_regexp[1])
    end

    def convert(text)
      text
    end

    priority :lowest
    converts /\..+$/ => '\0'
  end
end
