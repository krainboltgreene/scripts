class Array
  def add(index, item)
    if index.is_a?(Integer) then at index, item else push item end
  end
end

class Hash
  def add(key, value = nil)
    store key, value
  end
end


def document_from(keys, value, object = {})
  keys = keys.split "."
  last_object = keys.inject object do |memo, key|
    case
    when keys[keys.index(key).succ] == "*"
      memo.add key, []
    when key != "*"
      if memo.is_a? Array
        memo.push key => nil
        memo.first
      else
        memo.add key, {}
      end
    else
      memo
    end
  end
  p last_object
  last_object.add keys.last, value
  object
end


doc1 = document_from "profile.name", "Kurtis Rainbolt-Greene"
doc2 = document_from "profile.name", "Angela Englund"

p doc1
p doc2
# doc3 = doc1.merge doc2
# p doc3

