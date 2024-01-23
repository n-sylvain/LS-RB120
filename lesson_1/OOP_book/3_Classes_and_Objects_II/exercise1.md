Add a class method to your MyCar class that calculates the gas mileage (i.e. miles per gallon) of any car.

```ruby
class MyCar

  # code omitted for brevity...

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
end

MyCar.gas_mileage(13, 351)  # => "27 miles per gallon of gas"

```

