module Howl
  class Page < Template
    def output_path
      site.output_path(path.relative_path_from(site.pages_path).dirname + output_filename)
    end
  end
end
