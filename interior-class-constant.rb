class Outerclass
  class Innerclass
    def innermethod
      "Example text"
    end
  end

  def setup
    self.class.const_get("Innerclass").new.innermethod
  end
end


puts Outerclass.new.setup
