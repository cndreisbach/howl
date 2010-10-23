require 'howl'

task :default => :generate

desc "Generate this site"
task :generate do
  site = Howl::Site.new(File.dirname(__FILE__))
  site.write_to_disk
end
