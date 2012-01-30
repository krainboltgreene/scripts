module Enumerable
  def uniq_by
    r, s = [], {}
    each do |e|
      v = yield(e)
      next if s[v]
      r << e
      s[v] = true
    end
    r
  end
end

enumerable = [{id: 1, name: "Kurtis"}, {id: 2, name: "James"}, {id: 3, name: "Tony"}, {id: 4, name: "Kurtis"}]

p enumerable.uniq_by { |e| e[:name] }