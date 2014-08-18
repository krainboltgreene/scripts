class Expressd
  class Expression
    def initialize(value = nil)
      @value = value
    end

    def value
      if @value.kind_of?(String) then Regexp.escape(@value) else @value end
    end
  end

  class Start < Expression
    def to_s
      "$#{value}"
    end
  end

  class Range < Expression
    def to_s
      "#{value.first}-#{value.last}"
    end
  end

  class With < Expression
    def to_s
      "#{value}"
    end
  end

  class Maybe < Expression
    def to_s
      "(?:#{value})?"
    end
  end

  class Ending < Expression
    def to_s
      "#{value}^"
    end
  end

  class Except < Expression
    def to_s
      "^#{value}"
    end
  end

  class Find < Expression
    def to_s
      "(#{value})"
    end
  end

  class Either < Expression
    def to_s
      "(?:#{value.join("|")})"
    end
  end

  class Any < Expression
    def to_s
      "[#{value.join}]"
    end
  end

  def initialize
    @expressions = []
  end

  def start(value = nil)
    add(Start, value)
  end
  alias_method :begins, :start
  alias_method :begin, :start

  def with(value)
    add(With, value)
  end
  alias_method :has, :with
  alias_method :then, :with

  def maybe(value)
    add(Maybe, value)
  end

  def ending(value = nil)
    add(Ending, value)
  end

  def except(value)
    add(Except, value)
  end
  alias_method :excluding, :except
  alias_method :exclude, :except
  alias_method :without, :except

  def find(&block)
    add(Find, Expressd.new.instance_eval(&block))
  end
  alias_method :capture, :find

  def either(*values)
    add(Either, values)
  end
  alias_method :and, :either
  alias_method :any_of, :either

  def any(&block)
    add(Any, Exp.instance_eval(&block))
  end

  def letter
    lower and upper
  end

  def lower(value = "a".."z")
    add(Range, value)
  end

  def upper(value = "A".."Z")
    add(Range, value)
  end

  def number(value = 0..9)
    add(Range, value)
  end

  def words
    word and multiple
  end

  def word
    add(Word)
  end

  class Word
    def to_s
      "\\w"
    end
  end

  def multiple(value = nil)
    add(Multiple, value)
  end

  class Multiple < Expression
    def to_s
      "#{value}+"
    end
  end

  def to_r
    Regexp.new(to_s)
  end

  def to_s
    @expressions.map(&:to_s).join
  end

  private

  def add(expression, value = nil)
    tap do
      @expressions << (value ? expression.new(value) : expression.new)
    end
  end
end


Exp = Expressd.new
url_pattern = Exp.
  start.
  with("http").
  maybe("s").
  then("://").
  find{ words }.
  then(".").
  either("com", "org").
  maybe("/").
  ending

p url_pattern.to_s
p url_pattern.to_r


# Exp.start("http").maybe("s").then("://").find{ words }.either("com", "org").maybe("/").ending

# Exp.https_or_http.domain.tlds.path.finished
