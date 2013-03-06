class Hash
  def with_indifferent_access
    self
  end
end

def token_and_options(request)
  if request[/^Token (.*)/]
    values = Hash[$1.split(',').map do |value|
      value.strip!                      # remove any spaces between commas and values
      key, value = value.split(/\=\"?/) # split key=value pairs
      if value
        value.chomp!('"')                 # chomp trailing " in value
        value.gsub!(/\\\"/, '"')          # unescape remaining quotes
        [key, value]
      end
    end.compact]
    [values.delete("token"), values.with_indifferent_access]
  end
end

def new_token_and_options(request)
  authorization_request = request
  if authorization_request[/Token .+/]
    params = token_params_from authorization_request
    [params.shift.last, Hash[params].with_indifferent_access]
  end
end

def token_params_from(authorization)
  raw = authorization.sub(%r/^Token /, '').split %r/"\s*(?:,|;|\t+)\s*/
  rewrite_param_values params_array_from raw
end

def params_array_from(raw_params)
  raw_params.map { |param| param.split %r/=(.+)?/ }
end

def rewrite_param_values(array_params)
  array_params.each { |param| param.last.gsub! %r/^"|"$/, '' }
end

puts "# Text is: " + 'Token token="lifo"'
p  token_and_options('Token token="lifo"')
p  new_token_and_options('Token token="lifo"')
puts ""
puts "# Text is: " + 'Token token="lifo", algorithm="test"'
p  token_and_options('Token token="lifo", algorithm="test"')
p  new_token_and_options('Token token="lifo", algorithm="test"')
puts ""
puts "# Text is: " + 'Token token="li,fo", algorithm="te,st"'
p  token_and_options('Token token="li,fo", algorithm="te,st"')
p  new_token_and_options('Token token="li,fo", algorithm="te,st"')
puts ""
puts "# Text is: " + 'Token token="rcHu+HzSFw89Ypyhn/896A==", nonce="def"'
p  token_and_options('Token token="rcHu+HzSFw89Ypyhn/896A==", nonce="def"')
p  new_token_and_options('Token token="rcHu+HzSFw89Ypyhn/896A==", nonce="def"')
puts ""
puts "# Text is: " + 'Token token="rcHu+=HzSFw89Ypyhn/896A==f34", nonce="def"'
p  token_and_options('Token token="rcHu+=HzSFw89Ypyhn/896A==f34", nonce="def"')
p  new_token_and_options('Token token="rcHu+=HzSFw89Ypyhn/896A==f34", nonce="def"')
puts ""
puts "# Text is: " + 'Token token="rcHu+\\\\"/896A", nonce="def"'
p  token_and_options('Token token="rcHu+\\\\"/896A", nonce="def"')
p  new_token_and_options('Token token="rcHu+\\\\"/896A", nonce="def"')
puts ""
puts "# Text is: " + 'Token token="lifo"; algorithm="test"'
p  token_and_options('Token token="lifo"; algorithm="test"')
p  new_token_and_options('Token token="lifo"; algorithm="test"')
puts ""
puts "# Text is: " + 'Token token="lifo" algorithm="test"'
p  token_and_options('Token token="lifo" algorithm="test"')
p  new_token_and_options('Token token="lifo" algorithm="test"')
puts ""
puts "# Text is: " + "Token token=\"lifo\"\talgorithm=\"test\""
p  token_and_options("Token token=\"lifo\"\talgorithm=\"test\"")
p  new_token_and_options("Token token=\"lifo\"\talgorithm=\"test\"")
puts ""
puts "# Text is: " + 'Token token="\"quote\" pretty", algorithm="test"'
p  token_and_options('Token token="\"quote\" pretty", algorithm="test"')
p  new_token_and_options('Token token="\"quote\" pretty", algorithm="test"')
puts ""
puts "# Text is: " + 'Token token=""quote" pretty", algorithm="test"'
p  token_and_options('Token token=""quote" pretty", algorithm="test"')
p  new_token_and_options('Token token=""quote" pretty", algorithm="test"')
