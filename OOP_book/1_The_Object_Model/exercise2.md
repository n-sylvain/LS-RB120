What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.

A module allows us to group reusable code into one place. We use modules in our classes by using the `include` method invocation, followed by the module name. Modules are also used as a namespace.

The first purpose of a module is to extend the functionality of a class. Another use is namespacing, it allows to organize code better.

```ruby
module Study
end

class MyClass
  include Study
end

my_obj = MyClass.new
```

```ruby
module Swimmable
end

class Person
  include Swimmable
end

first_person = Person.new

module Careers
  class Engineer
  end

  class Teacher
  end
end

first_job = Careers::Teacher.new

```