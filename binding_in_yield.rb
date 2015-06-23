class ExampleObject
  def initialize(&block)
    self.instance_exec("argument", &block)
  end
end

ExampleObject.new do |bar|
  binding.pry
end
