require 'sass'

module Howl
  class SassConverter < Converter
    converts /\.s[ac]ss/ => '.css'

    def convert(text)
      sass_args = { :syntax => @template.extension.drop(1).to_sym, 
                    :load_paths => [@template.path.dirname] }
      Sass::Engine.new(text, sass_args).render 
    end
  end
end
