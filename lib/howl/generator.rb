require 'fileutils'

module Howl
  module Generator
    def self.generate(directory)
      directory = File.expand_path(directory)

      if file_in_the_way?(directory)
        puts "#{directory} already exists and is not an empty directory."
        exit
      end

      FileUtils.mkdir_p(directory)
      FileUtils.cp_r(File.join(File.dirname(__FILE__), 'sample_site', '.'), directory)
    end

    private

    def self.file_in_the_way?(directory)
      File.exists?(directory) &&
        (!(File.directory?(directory) && 
            Dir[File.join(directory, '*')].empty?))
    end
  end
end
