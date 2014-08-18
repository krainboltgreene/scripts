require "parslet"

class EBNFParser < Parslet::Parser
  rule(:eol) do
    match["\r|\n"]
  end

  rule(:eol?) do
    eol.repeat(0)
  end

  rule(:term) do
    match["a-Z\s"].repeat
  end

  rule(:list) do
    terminal >> (operator >> terminal).repeat(0)
  end

  rule(:first_quote) do
    str("'")
  end

  rule(:second_quote) do
    str('"')
  end

  rule(:start_optional) do
    str("[")
  end

  rule(:end_optional) do
    str("]")
  end

  rule(:start_repeated) do
    str("{")
  end

  rule(:end_repeated) do
    str("}")
  end

  rule(:start_grouped) do
    str("(")
  end

  rule(:end_grouped) do
    str(")")
  end

  rule(:start_special) do
    str("?")
  end

  rule(:end_special) do
    str("?")
  end

  rule(:nonspecials) do
    match["[^\?]"].repeat(1)
  end

  rule(:first_terminal) do
    first_quote >> match["[^']"].repeat(1) >> first_quote
  end

  rule(:second_terminal) do
    second_quote >> match['[^"]'].repeat(1) >> second_quote
  end

  rule(:terminal) do
    first_terminal | second_terminal
  end

  rule(:optional) do
    start_optional >> list >> end_optional
  end

  rule(:repeated) do
    start_repeated >> list >> end_repeated
  end

  rule(:grouped) do
    start_grouped >> list >> end_grouped
  end

  rule(:meta) do
    match["a-Z"] >> match["a-Z0-9"].repeat(0)
  end

  rule(:special) do
    start_special >> nonspecials >> end_special
  end

  rule(:empty) do

  end

  rule(:sequence) do
    optional | repeated | grouped | metas | terminal | special # | empty
  end

  rule(:assigner) do
    space? >> str("=") >> space?
  end

  rule(:terminator) do
    str(";")
  end

  rule(:definition) do
    term.as(:term) >> assigner.as(:assigner) >> sequence.as(:sequence) >> terminator.as(:terminator)
  end

  rule(:definitions) do
    definition.as(:definition) >> eol?
  end
end

EBNFParser.new.parse(%(
space = "\s" | "\t";
return = "\n" | "\r";
white space = { space | return };

upper alpha letters = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z";
lower alpha letters = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z";
letters = upper alpha letters | lower alpha letters;

numbers = "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
digits = "0" | numbers;
decimals = { digits } , ".", { digits };
negatives = "-", decimals | { digits };

allowed punctuation = "." | "?" | "!"| '"' | "'" | ",";
allowed typography =  "_" | "@" | "$" | "%" | "^" | "&" | "/" | "\" | "`" | "~";
allowed operators = "-" | "|" | "=" | "*" | "<" | ">" | "+";
grammar = allowed punctuation | allowed typography | allowed operators;

characters = letters | { digits } | decimals | negatives | grammar;

word = { characters };
definition = word, ":", expression;
))
