require 'hashie'

module Howl
  class View < Hashie::Mash
    def has_key?(key)
      key?(key) || respond_to?(key)
    end

    def [](key)
      super || (respond_to?(key) && send(key))
    end

    def posts
      if site? && site.respond_to?(:posts)
        site.posts
      end
    end
    
    # filters

    def format_date
      lambda do |text|
        time = Time.parse(text.to_s)
        time_format = self.date_format || "%b %-d, %Y at %-I:%M %P"
        time.strftime(time_format)
      end
    end
  end
end
