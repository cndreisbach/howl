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
  end
end
