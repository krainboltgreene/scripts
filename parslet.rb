require "parslet"

class Parslet::Atoms::Str
  def to_hash
    {
      "atom" => "str",
      "str" => str
    }
  end
end

class Parslet::Atoms::Sequence
  def to_hash
    {
      "atom" => "sequence",
      "parslets" => parslets.map(&:to_hash)
    }
  end
end

class Parslet::Atoms::Repetition
  def to_hash
    {
      "atom" => "repetition",
      "min" => min,
      "max" => max,
      "parslet" => parslet.to_hash
    }
  end
end

class Parslet::Atoms::Re
  def to_hash
    {
      "atom" => "re",
      "match" => match,
      "re" => re
    }
  end
end

class Parslet::Atoms::Named
  def to_hash
    {
      "atom" => "named",
      "name" => name,
      "parslet" => parslet.to_hash
    }
  end
end

class Parslet::Atoms::Entity
  def to_hash
    {
      "atom" => "entity",
      "name" => name,
      "parslet" => parslet.to_hash
    }
  end
end

class Parslet::Parser
  def to_hash
    {
      "atom" => "root",
      "root" => root.to_hash
    }
  end

  def self.from_hash(hash)
    parser = new
    parser.define_method(hash["name"]) do
      hash["parslet"].to_parslet
    end
  end
end

class Hash
  def to_parslet
    case fetch("atom")
    when "entity"
      Parslet::Atoms::Entity.new(fetch("name")).tap do |entity|
        entity.instance_variable_set("@parslet", fetch("parslet").to_parslet)
      end

    when "named"
      Parslet::Atoms::Named.new(fetch("parslet").to_parslet, fetch("name"))

    when "repetition"
      Parslet::Atoms::Repetition.new(fetch("parslet").to_parslet, fetch("min"), fetch("max"))

    when "sequence"
      Parslet::Atoms::Sequence.new(fetch("parslets").map(&:to_parslet))

    when "re"
      Parslet::Atoms::Re.new(fetch("match")).tap do |re|
        re.instance_variable_set("@re", fech("re"))
      end

    when "str"
      Parslet::Atoms::Str.new(fetch("str"))
    end
  end
end

class WhiskeyParser < Parslet::Parser
  root(:command)
  rule(:space) { match["\s"].repeat }
  rule(:space?) { space.maybe }
  rule(:username) { match["a-zA-Z0-9"].repeat }
  rule(:password) { match["a-zA-Z0-9"].repeat }
  rule(:arguments) { username.as(:username) >> space? >> password.as(:password) >> space? }
  rule(:control) { str("account").as(:control) }
  rule(:action) { str("create").as(:action) }
  rule(:command) { control >> space >> action >> space >> arguments }
end

parser = WhiskeyParser.new
hash = parser.to_hash
parslet = Parslet::Parser.from_hash(hash)
parser.parse("account create krainboltgreene 1234abcd")
