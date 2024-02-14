=begin
Disclaimer: I am not a TA, just a student like you.

Introductions: Name
               Location in country
               Location in course
               What do you want to cover today?
               - written, code spike-what and how? depth?
               - interview, scheduled, talking/examples
               - collaborator objects, `self`, study guide, OOP code
               - Lesson 2, written, what to know
               - OOP problems, self
=end

# class Produce
#   attr_reader :type

#   def initialize(type)
#     @type = type
#   end
# end

# class Corn < Produce; end

# class Raspberry < Produce; end

# p Corn.new('sweet').type
# p Raspberry.new('red').type

# module Danceable
#   def dance
#     "dance!"
#   end
# end

# class Ballerina
#   include Danceable
# end

# class Toddler
#   include Danceable
# end

# p Ballerina.new.dance
# p Toddler.new.dance

# class File
#   def click
#   end
# end

# class Paint
#   def click
#   end
# end

# On which lines in the following code does self refer to the instance of the MeMyselfAndI class referenced by i rather than the class itself? Select all that apply.
# module Callable
#   p self
# end

# class MeMyselfAndI
#   # p self
#   # include Callable

#   def self.me
#     self
#   end

#   def myself
#     self
#   end
# end

# # i = MeMyselfAndI.new
# # p i


# class FarmersMarket
#   attr_reader :featured_farmer

#   def initialize(featured_farmer)
#     @featured_farmer = featured_farmer
#   end
# end

# class Farmer
#   def initialize
#     @name = 'Bob'
#   end

#   def sell_produce
#     "sell veggies"
#   end
# end

# bob = Farmer.new
# tuesday_market = FarmersMarket.new(bob)
# p tuesday_market.featured_farmer.sell_produce
# class Person
#   p self
#   def initialize(name)
#     @name = name
#   end
# end

# class Cat
#   p self
#   def initialize(name, owner)
#     @name = name
#     @owner = owner
#   end
# end

# sara = Person.new("Sara")
# fluffy = Cat.new("Fluffy", sara)
# # Identify all custom defined objects that act as collaborator objects within the code.

# p fluffy
# SIDES = 22
#SIDES = 4
module Describable
  def describe_shape
    "I am a #{self.class} and have #{Quadrilateral::SIDES} sides."
  end
end

class Shape
  # SIDES = 9
  include Describable

  def self.sides
    self::SIDES
  end

  def sides
    # SIDES
    self.class::SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
end

class Square < Quadrilateral; end

p Square.sides
p Square.new.sides
p Square.new.describe_shape


# What is output and why? What does this demonstrate about constant scope? What does `self` refer to in each of the 3 methods above?

# Constant Resolution Path
  # 1. Searches Lexically
  # 2. Searches the Inheritance Chain
  # 3. Checks the Top Scope
