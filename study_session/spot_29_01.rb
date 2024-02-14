=begin
Name?
Where in the course are you?
What is the last thing you ate?
Any concepts or code snippets you want to talk about?

nathan
lesson 5
constants - scoping

nick
lesson 1

sylvain
lesson 5

Ilke
lesson 4
what is expected in written assessment

scott
lesson 5
=end


module Walk
  STR = "Walking"
end

module Run
  STR = "Running"
end

module Jump
  STR = "Jumping"
end

STR = 'outer'

module Bunnyable

  STR = 'inside bunny module'

  class Bunny
    include Bunnyable
    # STR = 'inside bunny'
    # include Jump
    # include Walk
    # include Run

    def show
      STR
    end

    def constant
      Outside::Bugs::STR
    end
  end

end


module Outside
  class Bugs < Bunny;
    #include Bunnyable
    # STR = 'inside bugs'
  end
end
# p Bugs.ancestors #[bugs, bunny, run, walk, jump, object, kernel, basicObject]
# p Bugs::STR # running

p Bunnyable::Bugs.new.constant #
# p Bunnyable::Bugs.new.show # 'inside bunny module'
