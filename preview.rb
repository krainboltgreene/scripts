

      # # Try the full version
      # cached = render_from_cache(url)
      # return cached if cached.present?

      # # If that fails, look it up
      # contents, cached = fetch_and_cache(url, args)
      # return cached if cached.present?
      # contents
require "digest"
class Preview
  attr_reader :url, :storage

  def initialize(url, storage, no_cache = true)
    @url = url
    @storage = storage
    @no_cache = no_cache
  end

  def to_html
    if cached?
      cached
    else
      content
    end
  end

  def no_cache?
    @no_cache
  end

  private

  def cached?
    no_cache? && storage.fetch(cache_key, nil)
  end

  def content
    "foo"
  end

  def cached
    "bar"
  end

  def cache_key
    "onebox:preview:#{Digest::SHA1.hexdigest(url)}"
  end
end

preview = Preview.new("http://github.com/krainboltgreene", SinatraAwesomeCache.cache)
p preview.to_html
