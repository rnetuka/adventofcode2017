class StateMachine

  def initialize
    @states = {}
    @rules = []
    @current_state = nil
  end

  def add_rule(from, input, to, callback = nil)
    @rules.append(Rule.new(from, input, to, callback))
  end

  def initial_state=(state)
    @current_state ||= state
  end

  def read(input)
    rule = @rules.find { |rule| rule.from == @current_state and rule.input == input }
    raise "No rule defined for #{@current_state}, #{input}" unless rule
    @current_state = rule.to
    rule.callback.call if rule.callback
  end

end

Rule = Struct.new(:from, :input, :to, :callback)