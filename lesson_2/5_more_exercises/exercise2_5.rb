class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata         # instance method
    @data + @data
  end

  def self.dupdata    # class method
    'ByeBye'
  end
end

thing = Something.new  # instantiate, create @data instance variable and assign it the value "Hello"
puts Something.dupdata # "ByeBye"
puts thing.dupdata     # "HelloHello"
