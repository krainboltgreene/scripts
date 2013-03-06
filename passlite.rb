require 'securerandom'
require 'io/console'
require 'fileutils'
require 'yaml'
require 'bcrypt'

CONFIG_DIRECTORY = File.join Dir.home, '.passlite', 'config'
SETTINGS_FILE = File.join CONFIG_DIRECTORY, 'settings.yml'

def ask(text, options = {})
  unless options[:newline]
    print text + " "

  else
    puts text
  end

  unless options[:secure]
    gets.chomp!
  else
    STDIN.noecho(&:gets).chomp!
  end
end

def report(text)
  puts text
end

def initialize
  report "Checking for passlite..."
  if File.exists? SETTINGS_FILE
    report "Found passite settings!"
    @settings = YAML.load SETTINGS_FILE
  else
    create_config_directory
    create_settings_file
    create_new_master_password
  end
end

def create_config_directory
  report "Creating config directory..."
  Dir.mkdirp CONFIG_DIRECTORY
end

def create_settings_file
  report "Creating settings file.."
  open SETTINGS_FILE do |file|
    file.write YAML.dump created_at: Time.now
  end
end

def create_new_master_password
  text = "What will be your master password? (DONT FORGET THIS)"
  password = ask text, newline: true, secure: true

  open SETTINGS_FILE do |file|
    file.write
  end
end

def ask_for_master_password
  password = ask "What's your master password?", secure: true
end
