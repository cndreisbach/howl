class String
  def drop(num)
    self.dup.split(//).drop(num).join
  end

  def slugify
    string = self.dup
    string.gsub!(/[^\x00-\x7F]+/, '')     # Remove anything non-ASCII entirely (e.g. diacritics).
    string.gsub!(/[^a-z0-9\-_]+/i, '-')
    string.downcase
  end
end

