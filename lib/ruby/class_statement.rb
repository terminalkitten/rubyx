module Ruby
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body

    def initialize( name , supe , body)
      @name , @super_class_name = name , supe
      case body
      when MethodStatement
        @body = Statements.new([body])
      when Statements
        @body = body
      when nil
        @body = Statements.new([])
      else
        raise "what body #{body}"
      end
    end

    def to_vool
      meths = body.statements.collect{|meth| meth.to_vool}
      Vool::ClassStatement.new(@name , @super_class_name, Vool::Statements.new(meths) )
    end

    def to_s(depth = 0)
      at_depth(depth , "class #{name}" , @body.to_s(depth + 1) , "end")
    end
  end
end
