module Howl
  class Site
    attr_accessor :root, :view

    def initialize(root)
      @root = Pathname.new(root)
      load_config
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

        if page.path.binary?
          FileUtils.copy(page.path, page.output_path)
        else
          page.output_path.open("w") do |fh|
            fh.write page.render
          end
        end
      end
    end

    private

    def load_config
      view = YAML.load(File.read(path "config.yml")) if path("config.yml").exist?
      view = {} unless view.is_a?(Hash)
      @view = View.new(view)
    end
  end
end
