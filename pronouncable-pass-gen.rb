def password(size = 24, options = {})
  constants = %w[b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr lt]
  vowels = %w[a e i o u y]
  characters = (0..size).map do |i|
    i.even? ? constants[rand(constants.size)] : vowels[rand(vowels.size)]
  end
  words = characters.each_slice(4).map(&:join)
  words.select! { |word| word.length > 2 }
  words.join("-")
end

p password
