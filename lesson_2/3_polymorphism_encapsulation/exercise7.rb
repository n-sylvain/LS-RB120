class Person
  # attr_reader :name

  # def name=(name)
  #   @name = "Mr. " + name.capitalize
  # end

  attr_writer :name

  def name
    "Mr. #{@name}"
  end
end

person1 = Person.new
person1.name = 'James'
puts person1.name
