module Howl
  class Post < Template
    include Comparable

    def date
      view.date? ? Time.parse(view.date) : File.mtime(path)
    end

    def <=>(other)
      self.date <=> other.date
    end

    def output_path
      site.output_path("posts") + date.strftime("%Y/%m/%d") + output_filename
    end

    def title
      view.title || path.basename(extension).to_s
    end

    def dom_id
      title.slugify
    end

    def link
      "/" + output_path.relative_path_from(site.output_path).to_s
    end

    def rendered_content
      render_view = view.dup
      render_view.delete('template')
      converter.convert(Mustache.render(@content, render_view))
    end
  end
end
