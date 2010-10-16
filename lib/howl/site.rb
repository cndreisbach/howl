module Howl
  class Site
    attr_accessor :root

    def initialize(root)
      @root = Pathname.new(root)
    end

    def path(path)
      root + path
    end

    def pages
      @pages ||= Dir[path "pages/*"].map { |path| Page.new(path, self) }
    end

    def posts
      @posts ||= Dir[path "posts/*"].map { |path| Post.new(path, self) }.sort
    end

    def templates
      @templates ||= Hash[Dir[root + "templates/*"].map { |path| 
        [Pathname.new(path).relative_path_from(path "templates").to_s, 
         Template.new(path, self)] 
      }]
    end

    def write_to_disk
      FileUtils.rm_r(path "site") if File.exist?(path "site")
      #raise (pages + posts).map(&:class).inspect
      (pages + posts).each do |page|
        FileUtils.makedirs(page.output_path.dirname)
        page.output_path.open("w") do |fh|
          fh.write page.render
        end
      end
    end
  end
end
