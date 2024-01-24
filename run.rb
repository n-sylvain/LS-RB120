class Box
  def initialize(w, h)
    @width = w
    @height = h
  end

  def printWidth
    @width
  end

  def printHeight
    @height
  end
end

box = Box.new(10, 20)

x = box.printWidth
y = box.printHeight

puts x
puts y
