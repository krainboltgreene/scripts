require 'ostruct'

class Formula < OpenStruct
  def initialize(name, details = {})
    raise TypeError unless name.is_a? Symbol
    raise TypeError unless details.is_a? Hash
    formula = { name: name }.merge! details
    marshal_load formula
  end
end

Formula.new :redis, {
  source: '',
  version: '',
  description: '',
  instructions: {
    pre: '',
    post: ''
  }
}

require 'minitest/autorun'

class TestFormula < MiniTest::Unit::TestCase

  def setup
    @exam
    @example = Formula.new

  end
  def test_instructions_getter
    fail
  end

  def test_name_getter
    fail
  end

  def test_source_getter
    fail
  end

  def test_description_getter
    fail
  end

  def test_formula_raises_type_if_name_isnt_symbol
    fail
  end

  def test_formula_raises_type_if_details_isnt_hash
    fail
  end

  def test_attributes
    fail "Should return a hash with the details of the object"
  end

  def test_to_json
    fail "Should return a JSON parsable object of the details"
  end

  def test_to_yaml
    fail "Should return a YAML parsable object of the details"
  end
end
