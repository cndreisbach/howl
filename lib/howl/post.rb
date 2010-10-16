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
      site.path("site/posts") + date.strftime("%Y/%m/%d") + output_filename
    end

    def title
      view.title || path.basename(extension).to_s
    end

    def dom_id
      title.slugify
    end
  end
end
