module TIS100

  class Socket
    def initialize
      @buffer = nil
    end

    def connect buffer
      @buffer = buffer
    end

    def read
      @buffer.read
    end

    def write data
      @buffer.write data
    end

    def can_read?
      @buffer.can_read?
    end

    def can_write?
      @buffer.can_write?
    end

    def state_string
      @buffer ? @buffer.state_string : nil
    end

  end

  class Buffer
    def initialize(data=nil)
      @data = data
    end

    def read
      data = @data
      @data = nil
      data
    end

    def write data
      nil if @data
      @data = data
    end

    def can_read?
      !!@data
    end

    def can_write?
      !@data
    end

    def state_string
      @data
    end
  end

  class Register
    def initialize
      @data = 0
    end

    def read
      @data
    end

    def write data
      @data=data
    end

    def can_read?
      true
    end

    def can_write?
      true
    end

    def state_string
      @data
    end
  end

end