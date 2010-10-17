module Howl
  class Site
    attr_accessor :root

    def initialize(root)
      @root = Pathname.new(root)
    end

    def path(path)
      root + path
    end

    def posts_path(path = '')
      root + "posts" + path
    end

    def templates_path(path = '')
      root + "templates" + path
    end

    def pages_path(path = '')
      root + "site" + path
    end

    def output_path(path = '')
      root + "generated" + path
    end

    def pages
      @pages ||= Dir[pages_path "**/*.*"].map { |path| Page.new(path, self) }
    end

    def posts
      @posts ||= Dir[posts_path "**/*.*"].map { |path| Post.new(path, self) }.sort
    end

    def templates
      @templates ||= Hash[Dir[templates_path('*')].map { |path| 
        [Pathname.new(path).relative_path_from(path "templates").to_s, 
         Template.new(path, self)] 
      }]
    end

    def write_to_disk
      FileUtils.rm_r(output_path) if File.exist?(output_path)
      (pages + posts).each do |page|
        FileUtils.makedirs(page.output_path.dirname)
        page.output_path.open("w") do |fh|
          fh.write page.render
        end
      end
    end
  end
end
