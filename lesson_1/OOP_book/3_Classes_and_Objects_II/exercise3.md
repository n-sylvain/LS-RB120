When running the following code...

```ruby
class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
```

We get the following error...

```ruby
test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

```


Why do we get this error and how do we fix it?

We get this error because attr_reader only creates a getter method. When we try to reassign the name instance variable to "Bob", we need a setter method called name=. We can get this by changing attr_reader to attr_accessor or attr_writer if we don't intend to use the getter functionality.

```ruby
class Person
  attr_accessor :name
  # attr_writer :name ## => This also works but doesn't allow getter access
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
```

