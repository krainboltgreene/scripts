
require "strscan"



class Deserializer
  def initialize(raw)
    scanner = StringScanner.new(raw)
    @length = scanner.scan_until(/:/).gsub(/:/, "")
    @data = scanner.peek(length)
    scanner.pos = scanner.pos + length
    @klass = scanner.get_byte
  end

  def dump
    klass.
  end

  def klass
    case @klass
    when "," then String
    when "#" then Integer
    when "^" then Float
    when "!" then Boolean
    when "~" then Nil
    when "}" then Hash
    when "]" then Array
    end
  end

  def length
    @length.to_i
  end

  class String
  end

  class Integer
  end

  class Float
  end

  class Boolean
  end

  class Nil
  end

  class Hash
  end

  class Array
  end
end

deserialized = {
  "person" => {
    "name" => "Kurtis Rainbolt-Greene",
    "age" => 26,
    "bank" => 145.95,
    "alive" => true,
    "likes" => [ "Magic", 13 ],
    "friends" => [
      {
        "name" => "Angela",
        "age" => 31
      },
      {
        "name" => "James",
        "age" => 35
      }
    ]
  }
}

serialized = "208:6:person,194:4:name,22:Kurtis Rainbolt-Greene,3:age,2:26#8:dislikes,0:~5:alive,4:true!5:likes,13:5:Magic,2:13#]7:friends,61:27:3:age,2:31#4:name,6:Angela,}26:3:age,2:35#4:name,5:James,}]4:bank,10:145.950000^}}"


deserializer = Deserializer.new(serialized)

p deserializer
deserializer.dump == deserialized
