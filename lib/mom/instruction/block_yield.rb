module Mom

  # A BlockYield calls an argument block. All we need to know is the index
  # of the argument, and the rest is almost as simple as a SimpleCall

  class BlockYield < Instruction
    attr :arg_index

    def initialize(index)
      @arg_index = index
    end

    def to_s
      "BlockYield[#{arg_index}] "
    end

    def to_risc(compiler)
      return_label = Risc.label("block_yield", "continue_#{object_id}")
      index = arg_index
      compiler.build("BlockYield") do
        next_message! << message[:next_message]
        return_address! << return_label
        next_message[:return_address] << return_address

        block_reg! << message[:arguments]
        block_reg << block_reg[index]

        message << message[:next_message]
        add_code Risc::DynamicJump.new("block_yield", block_reg )
        add_code return_label
      end
    end
  end

end
