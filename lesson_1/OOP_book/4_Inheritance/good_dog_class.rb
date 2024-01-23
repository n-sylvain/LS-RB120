class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

class BadDog < Animal
  def initialize(age, name)
    super(name)
    @age = age
  end
end

class Bear < Animal
  def initialize(color)
    super()
    @color = color
  end
end

# bruno = GoodDog.new("brown")

# p bruno

p BadDog.new(2, "bear")
p bear = Bear.new("black")
