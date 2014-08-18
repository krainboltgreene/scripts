def require_relative(path)
  puts File.read(path + ".rb")
end

require_relative "required_file"
