class Job
  UNIFORM = false

  def need_uniform?
    UNIFORM
  end
end

class Fireman < Job
  UNIFORM = true
end

john = Fireman.new

p john.need_uniform?
