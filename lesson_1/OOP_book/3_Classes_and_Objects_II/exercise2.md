Override the to_s method to create a user friendly print out of your object.

```ruby
class MyCar
  # code omitted for brevity...

  def to_s
    "My car is a #{color}, #{year}, #{@model}!"
  end
end

my_car = MyCar.new("2010", "Ford Focus", "silver")
puts my_car  # => My car is a silver, 2010, Ford Focus.

## Note the "puts" calls "to_s" automatically.

```

