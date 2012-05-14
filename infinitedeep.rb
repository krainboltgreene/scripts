e = Hash.new do |block, key|
  block[key] = Hash.new &block.default_proc
end
