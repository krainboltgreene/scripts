module ExampleModule
	  def amethod
		    end
end


class AClass
end

apre_imethods = AClass.instance_methods
apre_smethods = AClass.singleton_methods

class AClass
	  include ExampleModule
	    extend ExampleModule
end

p AClass.instance_methods - apre_imethods
p AClass.singleton_methods - apre_smethods

class BClass
end

bpre_imethods = BClass.instance_methods
bpre_smethods = BClass.singleton_methods

class BClass
	  extend ExampleModule
	    include ExampleModule
end

p BClass.instance_methods - bpre_imethods
p BClass.singleton_methods - bpre_smethods

opre_imethods = Object.instance_methods
opre_smethods = Object.singleton_methods

class Object
	  include ExampleModule
	    extend ExampleModule
end

p Object.instance_methods - opre_imethods
p Object.singleton_methods - opre_smethods
