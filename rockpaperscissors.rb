OPTIONS = ["rock", "paper", "scissors"]

def prompt(blah)
  "rock"
end

user_choice = prompt("What is your choice?")

computer_choice = OPTIONS.sample

def compare(user, computer)
  case
    when user == computer then "The result is a tie!"
    when winner?(user, computer) then "User wins"
    when winner?(computer, user) then "Computer wins"
  end
end

def winner?(user, computer)
  user == "rock" && computer == "scissors" ||
  user == "scissors" && computer == "paper" ||
  user == "paper" && computer == "rock"
end

puts "User picked: #{user_choice}"
puts "Computer picked: #{computer_choice}"
puts compare(user_choice, computer_choice)
