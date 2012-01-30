require 'ostruct'

class ClosedStruct < OpenStruct
  @@keys ||= []
  def initialize(table)
    super table
    @@keys.map!(&:to_sym)
    bad_keys = @table.each_key.reject { |key| @@keys.include? key }
    raise ArgumentError, "Key #{bad_keys.join(', ')} not found" unless bad_keys.empty?
  end
end

class Profile < ClosedStruct
  @@keys = [:name, :age]

end

p Profile.new name: "Kurtis Rainbolt-Greene", age: 23, likes: ["Magic", "Ruby"]