module TIS100
  class Node
    def initialize code = []
      @channels = {:up => Socket.new, :left => Socket.new, :right => Socket.new, :down => Socket.new, :acc => Register.new}
      @code = code
      @pc = 0
    end

    def [] index
      @channels[index]
    end

    def extract_operands(*args)
      args.map!{|op|
        if op =~ /^\d+$/
          Buffer.new(op.to_i)
        elsif @channels.keys.member?(op.to_sym)
          @channels[op.to_sym]
        else
          raise "Unknown operand #{op}"
        end
      }
    end

    def exec
      success = false
      case @code[@pc]
      when /^mov\s+(\w+)[, ]\s*(\w+)$/
        a, b = extract_operands $1, $2
        success = mov a, b
      when /^add\s+(\w+)$/
        a, b = extract_operands $1
        success = add a
      else
        raise "Unimplemented command #{@code[@pc]}"
      end
      if success
        @pc += 1
        @pc = @pc % @code.length
      end
    end

    def state_string
      "@#{@pc},#{@channels.values.map(&:state_string).join(',')};"
    end

    def mov a, b
      if a.can_read? && b.can_write?
        b.write(a.read)
      end
    end

    def add a
      if a.can_read?
        @channels[:acc].write(a.read + @channels[:acc].read)
      end
    end

  end

  class InputNode < Node # special node
    attr_writer :data
    def initialize
      @channel = Socket.new
      super
    end

    def connect dest
      @channel.connect dest
    end

    def exec
      mov(Buffer.new(@data.shift), @channel) if @channel.can_write?
    end

    def state_string
      "@#{@data.join','};"
    end

  end

  class OutputNode < Node #special node
    attr_reader :data
    def initialize
      @channel = Socket.new
      @data = []
      super
    end

    def connect dest
      @channel.connect dest
    end

    def exec
      if val = @channel.read
        @data.push(val)
      end
    end

    def state_string
      "@#{@data.join','};"
    end


  end

end
