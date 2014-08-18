require "google/api_client"
require "json"
require "pry"

class Client
  YOUTUBE_SCOPE = "https://www.googleapis.com/auth/youtube"
  YOUTUBE_API_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"

  attr_reader :client
  attr_reader :service
  attr_reader :key

  def initialize(key)
    @client = Google::APIClient.new(key: key, authorization: nil)
    @service = client.discovered_api(YOUTUBE_API_NAME, YOUTUBE_API_VERSION)
  end

  def execute(params)
    client.execute(params).data
  end
end

module Resource
  attr_reader :client

  def service
    client.service
  end

  def call
    {
      api_method: list,
      parameters: parameters
    }
  end

  def list
    service.send(self.class.const_get("NAME")).list
  end
end

class Channel
  include Resource

  NAME = :channels

  def initialize(id, client)
    @id = id
    @client = client
    @resource = @client.execute(call).items.first
  end

  def playlists
    details.related_playlists
  end

  def uploads
    Playlist.new(playlists.uploads, @client).videos
  end

  def details
    @resource.content_details
  end

  def parameters
    {
      id: @id,
      part: ["snippet", "contentDetails"]
    }
  end
end

class Playlist
  include Resource

  NAME = :playlist_items

  def initialize(id, client)
    @id = id
    @client = client
    @resource = @client.execute(call)
  end

  def total
    details.total_results
  end

  def details
    @resource.page_info
  end

  def videos
    pages.map(&:videos).flatten
  end

  def pages
    (1..page_count.round).map do
      if @current_page
        @current_page = Page.new(@id, client, @current_page.next_page)
      else
        @current_page = Page.new(@id, client)
      end
    end
  end

  def page_count
    total / Page::MAX_RESULTS.to_f
  end

  def parameters
    {
      part: ["snippet"],
      playlistId: @id
    }
  end
end

class Page
  include Resource

  NAME = :playlist_items
  MAX_RESULTS = 50

  def initialize(playlist, client, token = nil)
    @playlist = playlist
    @client = client
    @token = token
    @resource = @client.execute(call)
  end

  def videos
    @resource.items.map do |item|
      Video.new(item)
    end
  end

  def next_page
    @resource.next_page_token
  end

  def parameters
    {
      part: ["snippet"],
      playlistId: @playlist,
      maxResults: MAX_RESULTS,
      pageToken: @token
    }
  end
end

class Video
  SERIES_NAMES = [
    "Game Grumps VS",
    "Steam Rolled",
    "Steam Train",
    "Game Grumps",
    "GameGrumps"
  ].join("|")
  DELIMITER_PATTERN = /(?:\:|\s-)/
  SUBTITLE_NAME_EXCEPTIONS = [
    "Mary-Kate and Ashley",
    "Zelda",
    "Castlevania III",
    "Doctor Who"
  ].map { |name| "#{name}:.+?" }.join("|")
  ONE_WORD_SERIES_PATTERN = /GameGrumps/
  ANIMATED_PATTERN = /^Game Grumps Animated/
  OLD_VERSUS_PATTERN = /^Game Grumps VS/
  GAME_PATTERN = /^(#{SUBTITLE_NAME_EXCEPTIONS}|.+?)#{DELIMITER_PATTERN}/
  PART_PATTERN = /part (\d+)/i
  SERIES_PATTERN = /#{SERIES_NAMES}/

  attr_reader :id

  def initialize(model)
    @id = model.snippet.resource_id.video_id
    @title = model.snippet.title
    @series = @title.scan(SERIES_PATTERN).first || "Special"
    @game = @title.scan(GAME_PATTERN).flatten.first
    @part = @title.scan(PART_PATTERN).flatten.first || 0
  end

  def series
    case
    when @title.match(/^Zelda: A Link to the Past/)
      "Game Grumps"
    when @title.match(OLD_VERSUS_PATTERN)
      "Game Grumps VS"
    when @title.match(ANIMATED_PATTERN)
      "Special"
    when @game.nil? then "Announcement"
    when @series.match(ONE_WORD_SERIES_PATTERN)
      "Game Grumps"
    else
      @series
    end.strip
  end

  def game
    case
    when @title.match(OLD_VERSUS_PATTERN)
      @title.split("-")[1]
    when @title.match(ANIMATED_PATTERN)
      "Game Grumps Animated"
    when @game.nil?
      "Announcement"
    when @game.include?("Rematch")
      @game.gsub("Rematch", "")
    else
      @game
    end.strip
  end

  def title
    case
    when game == "Announcement"
      @title
    when series == "Special"
      @title.
        gsub(ANIMATED_PATTERN, "").
        gsub(DELIMITER_PATTERN, "")
    when part.zero?
      "Single"
    else
      @title.
        gsub(SERIES_PATTERN, "").
        gsub(PART_PATTERN, "").
        gsub(GAME_PATTERN, "").
        gsub(series, "").
        gsub(DELIMITER_PATTERN, "")
    end.strip
  end

  def part
    @part.to_i
  end

  def to_hash
    {
      "id" => id,
      "series" => series,
      "game" => game,
      "title" => title,
      "part" => part
      "raw" => @title
    }
  end
end


client = Client.new("AIzaSyDGD-nEOGh4lZeGijkV8s83p2GDMj-4X8c")
channel = Channel.new("UC9CuvdOVfMPvKCiwdGKL3cQ", client)

File.open("videos.json", "w") do |file|
  file.write JSON.pretty_generate(channel.uploads.map(&:to_hash))
end
