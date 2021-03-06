module Vool

  # A Yield is a lot like a Send, which is why they share the base class CallStatement
  # That means it has a receiver (self), arguments and an (implicitly assigned) name
  #
  # On the ruby side, normalisation works pretty much the same too.
  #
  # On the way down to Mom, small differences become abvious, as the block that is
  # yielded to is an argument. Whereas in a send it is either statically known
  # or resolved and cached. Here it is dynamic, but sort of known dynamic.
  # All we do before calling it is check that it is the right type.
  class YieldStatement < CallStatement

    # A Yield breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a SimpleCall,
    def to_mom( compiler )
      @parfait_block = @block.to_mom(compiler) if @block
      @receiver = SelfExpression.new(compiler.receiver_type) if @receiver.is_a?(SelfExpression)
      yield_call(compiler)
    end

    # this breaks into two parts:
    # - check the calling method and break to a (not implemented) dynamic version
    # - call the block, that is the last argument of the method
    def yield_call(compiler)
      method_check(compiler) << yield_arg_block(compiler)
    end

    # check that the calling method is the method that the block was created in.
    # In that case variable resolution is reasy and we can prceed to yield
    # Note: the else case is not implemented (ie passing lambdas around)
    #      this needs run-time variable resolution, which is just not done.
    #      we brace ourselves with the check, and exit (later raise) if . . .
    def method_check(compiler)
      ok_label = Mom::Label.new("method_ok_#{self.object_id}")
      compile_method = Mom::SlotDefinition.new( compiler.get_method , [])
      runtime_method = Mom::SlotDefinition.new( :message , [ :method] )
      check = Mom::NotSameCheck.new(compile_method , runtime_method, ok_label)
      # TODO? Maybe create mom instructions for this
      #builder = compiler.builder("yield")
      #Risc::Builtin::Object.exit_sequence(builder)
      #check << builder.built
      check << ok_label
    end

    # to call the block (that we know now to be the last arg),
    # we do a message setup, arg transfer and the a arg_yield (which is similar to dynamic_call)
    def yield_arg_block(compiler)
      arg_index = compiler.get_method.arguments_type.get_length - 1
      setup  = Mom::MessageSetup.new( arg_index )
      mom_receive = @receiver.slot_definition(compiler)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index| # +1 because of type
        args << Mom::SlotLoad.new( arg_target + [index + 1] , arg.slot_definition(compiler))
      end
      setup << Mom::ArgumentTransfer.new( mom_receive , args )
      setup << Mom::BlockYield.new( arg_index )
    end

  end
end
