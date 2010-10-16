module Howl
  class Page < Template
    def output_path
      site.path("site") + path.relative_path_from(site.path "pages").dirname + output_filename
    end
  end
end
