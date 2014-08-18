require "json"
require "pry"

class Collection
  attr_reader :series

  def initialize(videos)
    @series = videos.group_by(&:series).map do |series_name, series_videos|
      Series.new(series_name, series_videos)
    end
  end

  def series
    @series.map(&:to_html).join("\n")
  end

  def to_html
    """
    <!DOCTYPE html>
    <html>
      <head>
        <title>Game Grumps - The Collection</title>
        <link rel=\"stylesheet\" type=\"text/css\" href=\"http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/css/bootstrap.min.css\">
      </head>
      <body>
        <article class=\"serieses well\">
          #{series}
        </article>
      </body>
    </html
    """
  end
end

class Series
  attr_reader :name
  PANEL = {
    "Game Grumps" => "success",
    "Game Grumps VS" => "info",
    "Steam Rolled" => "warning",
    "Steam Train" => "danger",
    "Announcement" => "primary"
  }

  def initialize(name, videos)
    @name = name
    @games = videos.group_by(&:game).map do |game_name, game_videos|
      Game.new(game_name, game_videos)
    end
  end

  def games
    @games.map(&:to_html).join("\n")
  end

  def to_html
    """
    <section class=\"series alert alert-#{PANEL[name]}\">
      <header class=\"page-header\">
        <h1>#{name}</h1>
      </header>
      <article class=\"games\">
        #{games}
      </article>
    </section>
    """
  end
end

class Game
  attr_reader :name

  def initialize(name, videos)
    @name = name
    @videos = if videos.size == 1 then videos else videos.sort_by(&:part) end
  end

  def videos
    @videos.map(&:to_html).join("\n")
  end

  def to_html
    """
    <section class=\"game panel panel-primary\">
      <header class=\"panel-heading\">
        <h4>#{name}</h4>
      </header>
      <ol class=\"videos list-group\">
        #{videos}
      </ol>
    </section>
    """
  end
end

class Video
  attr_reader :id, :series, :game, :title, :part
  def initialize(raw)
    @raw = raw
    @id = raw["id"]
    @series = raw["series"]
    @game = raw["game"]
    @title = raw["title"]
    @part = raw["part"]
  end

  def to_html
    """
      <li class=\"video list-group-item\" #{data} >
        <a href=#{uri.inspect}>#{title}</a>
      </li>
    """
  end

  private

  def uri
    "https://www.youtube.com/watch?v=#{@id}"
  end

  def data
    @raw.map { |key, value| "data-#{key}=#{value.inspect}" }.compact.join(" ")
  end
end

videos = JSON.parse(File.read("videos.json")).map do |json|
  Video.new(json)
end

collection = Collection.new(videos)

File.open("videos.html", "w") do |file|
  file.write(collection.to_html)
end
