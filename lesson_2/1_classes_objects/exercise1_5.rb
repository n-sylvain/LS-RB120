# class Cat
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def greeting
#     puts "Hello! My name is #{self.name}"
#   end
# end

# kitty = Cat.new('Sophie')
# kitty.greeting

class Cat
  def initialize(name)
    @name = name
    puts "Hello! My name is #{@name}"
  end
end

kitty = Cat.new('Sophie')
