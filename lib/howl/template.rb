module Howl
  class Template
    attr_accessor :view, :content, :site, :path, :extension

    def initialize(path, site)
      @site = site
      @path = Pathname.new(path)
      @extension = @path.extname
      load_file
    end

    def ==(other)
      self.path == other.path && self.class == other.class
    end

    def output_filename
      path.basename.sub(/#{extension}$/, converter.extension)
    end

    def converter
      unless @converter
        converter_class = Converter.subclasses.find do |converter|
          converter.matches? @extension
        end
        converter_class ||= Converter

        @converter = converter_class.new(self)
      end

      @converter
    end

    def render(render_view = {})
      render_view.merge!(@view)
      rendered = converter.convert(Mustache.render(@content, render_view))
      template = render_view.delete("template")

      if template
        if @site.templates[template + @extension]
          rendered = @site.templates[template + @extension].render(
              render_view.merge("content" => rendered))
        else
          puts "Warning: Template #{template + @extension} does not exist in file #{path}"
          rendered
        end
      end

      rendered
    end

    private

    def load_file
      content = @path.read
      view, content = content.split("\n\n", 2)

      if test_for_yaml(view)
        @content = content
        view = YAML.load(view)
      else
        @content = "#{view}\n\n#{content}".strip
        view = {}
      end

      @view = View.new(view.merge(:site => site))
    end

    def test_for_yaml(view)
      begin
        view = YAML.load(view)
        view.is_a?(Hash)
      rescue ArgumentError
        false
      end
    end
  end
end
