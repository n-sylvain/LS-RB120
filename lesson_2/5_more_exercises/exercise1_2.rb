class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    # @name.upcase!
    "My name is #{@name.upcase}."
  end
end

# name = 'Fluffy'
# fluffy = Pet.new(name)
# puts fluffy.name
# puts fluffy
# puts fluffy.name
# puts name

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

=begin
further exploration

On line 1 we're initializing the local variable name to the integer 42. We're then instantiating a new object
fluffy from the class Pet on line 2, with name being passed in as an argument. Within the initialize instance method,
name has the #to_s method called on it. When #to_s is called on an integer object, its returning the string
representation of the integer. At this point, name and @name are no longer referencing the same object.
end

Even if #to_s mutated the caller, the output would not change as integers are immutable. So, on line 3 where we see
name += 1, what is happening is name is being reassigned to the return value of the current value referenced by
name + 1. @name and name would still be referencing different objects.end
=end
