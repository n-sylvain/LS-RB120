module Coatable
  def coating
    "I'm covered in chocolate"
  end
end

class JaffaCake
  include Coatable
end

class Raisin
  include Coatable
end

snacks = [JaffaCake.new, Raisin.new]
snacks.each { |snack| puts snack.coating }
