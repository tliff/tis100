module TIS100
  class Machine
    def initialize(&description)
      @inputs = []
      @outputs = []
      @nodes = []
      instance_eval(&description)
    end

    def input
      i = InputNode.new
      @inputs << i
      i
    end

    def output
      o = OutputNode.new
      @outputs << o
      o
    end

    def connect a, b
      buffer = Buffer.new
      a.connect buffer
      b.connect buffer
    end

    def node(code)
      node = Node.new(code)
      @nodes << node
      node
    end

    def run(input)
      states = []
      state = nil
      @inputs.zip(input).each do |input, data|
        input.data = data
      end
      until states.member? state
        states << state
        [@inputs, @nodes, @outputs].flatten(1).each(&:exec)
        state = [@inputs, @nodes, @outputs].flatten(1).map(&:state_string).join
      end
      @outputs.map(&:data)
    end
  end
end