class Banner
  attr_writer :message

  def initialize(message)
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  attr_reader :message

  def horizontal_rule
    "+-" + "-" * self.message.size + "-+"
  end

  def empty_line
    "| " + " " * self.message.size + " |"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner
