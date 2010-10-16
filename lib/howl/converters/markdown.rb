require 'rdiscount'

module Howl
  class MarkdownConverter < Converter
    converts ".md" => ".html"
    converts ".mdown" => ".html"
    converts ".markdown" => ".html"
    priority :highest

    def convert(text)
      RDiscount.new(text).to_html
    end
  end
end
