require "letsfreckle"
require "csv"

LetsFreckle.configure do
  account_host "decielo"
  username "me@kurtisrainboltgreene.name"
  token "p869kp1fpz84oky02lc18qbevy9nkoa"
end

data = CSV.read("hours.csv")
keys = data.shift
entries = data.map {|a| Hash[ keys.zip(a) ]}

entries.each do |entry|
  id = case entry["Project"]
  when "Finovate" then 133708
  when "Makindo" then 138221
  end

  description = unless entry["Note"].include?("Daily")
    "Development, #{entry["Note"]}"
  else
    entry["Note"]
  end

  begin
    LetsFreckle::Entry.create date: entry["Date"], project_id: id, minutes: entry["Hours rounded"], description: description
  rescue
    p entry
  end
end
