module Bosl
  Compiler.class_eval do
#    function attr_reader  :name, :params, :body , :receiver
    def on_function  expression
#      puts expression.inspect
      return_type , name , parameters, kids , receiver = *expression
      name =  name.to_a.first
      args = parameters.to_a.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.type == :parameter
        p[2]
      end

      if receiver
        # compiler will always return slot. with known value or not
        r = receiver.first
        if( r.is_a? Parfait::Class )
          class_name = r.value.name
        else
          if( r != :self)
            raise "unimplemented case in function #{r}"
          else
            r = Virtual::Self.new()
            class_name = method.for_class.name
          end
        end
      else
        r = Virtual::Self.new()
        class_name = method.for_class.name
      end
      new_method = Virtual::MethodSource.create_method(class_name, name , args )
      new_method.source.receiver = r
      new_method.for_class.add_instance_method new_method

      old_method = @method
      @method = new_method

      #frame = frame.new_frame
      kids.to_a.each do |ex|
        return_type = process(ex)
        raise return_type.inspect if return_type.is_a? Virtual::Instruction
      end
      @method = old_method
      new_method.source.return_type = return_type
      Virtual::Return.new(return_type)
    end
  end
end