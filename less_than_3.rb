def capture_image(phrase)
  `imagesnap #{titlized(phrase)}.jpg`
end

def ask(phrase)
  speak "You asked me #{phrase.gsub(/\?/,'')} and my answer is:"
  case phrase
  when /fairest/ then answer_fairest(phrase)
  end
end

def speak(phrase)
  `say #{phrase}`
end

def view_image(phrase)
  puts `jp2a #{titlized(phrase)}.jpg`
end

def titlized(phrase)
  phrase.gsub /\W+/, "_"
end

def answer_fairest(phrase)
  capture_image(phrase)
  view_image(phrase)
  speak "The fairest woman in the world is you!"
end

def swirl
  """
                        ____
                   ____ \\__ \\
                   \\__ \\__/ / __
                   __/ ____ \\ \\ \\6   ____
                  / __ \\__ \\ \\/ / __ \\__ \\
             ____ \\ \\ \\__/ / __ \\/ / __/ / __
        ____ \\__ \\ \\/ ____ \\/ / __/ / __ \\ \\ \\7
        \\__ \\__/ / __ \\__ \\__/ / __ \\ \\ \\ \\/
        __/ ____ \\ \\ \\5_/ ____ \\ \\ \\ \\/ / __
       / __ \\__ \\ \\/ ____ \\__ \\ \\/ / __ \\/ /
       \\ \\ \\__/ / __ \\__ \\__/ / __ \\ \\ \\__/
        \\/ ____ \\/ / __/ ____ \\ \\ \\2\\/ ____
           \\__ \\__/ / __ \\__ \\ \\/ / __ \\__ \\
           4_/ ____ \\ \\ \\__/ / __ \\/ / __/ / __
          / __ \\__ \\ \\/ ____ \\/ / __/ / __ \\/ /
          \\/ / __/ / __ \\__ \\__/ / __ \\/ / __/
          __/ / __ \\ \\ \\3_/ ____ \\ \\ \\__/ / __
         / __ \\ \\ \\ \\/ ____ \\__ \\ \\/ ____ \\/ /
         \\ \\ \\ \\/ / __ \\__ \\__/ / __ \\__ \\__/
          \\/ / __ \\/ / __/ ____ \\ \\ \\1_/
             \\ \\ \\__/ / __ \\__ \\ \\/
              \\/      \\ \\ \\__/ / __
                       \\/ ____ \\/ /
                          \\__ \\__/
                         0__/
  """
end

loop do
  puts swirl
  speak("How may I help you, oh wonderful wizard of all the land?")
  print "Ask me anything: "
  phrase = gets.chomp!
  ask(phrase)
end
