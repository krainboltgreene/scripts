

  def create_player
    name = confirm(:name, "What is your full name?")
    gender = confirm(:gender, "How should we address you?", ["guy", "gal", "person"])
    age = confirm(:age, "What is your age?")
    savings = rand(1..age.to_i) * 100
    seed = rand(1..1000)
    bank = seed + savings / @difficulty
    Player.new(name, gender, age, bank)
  end

  def confirm(field, message, options = [])
    confirmed = false
    until confirmed
      if options.empty?
        print "#{message} "
      else
        puts message
        puts options.map.with_index { |option, index| "#{index}: #{option}" }.join("\n")
      end
      value = gets.chomp!
      print "Did you mean to enter #{value} for #{field}? [y/n] "
      confirmed = true if gets.chomp! == "y"
    end
    value
  end
