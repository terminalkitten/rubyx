module Vool
  class MethodStatement < Statement
    attr_reader :name, :args , :body

    def initialize( name , args , body )
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
    end

    def to_mom(clazz)
      raise( "no class in #{self}") unless clazz
      method = clazz.add_method_for(name , make_arg_type , make_frame , body )
      compiler = method.compiler_for(clazz.instance_type)
      each do |node| ## TODO: must account for nested blocks (someday)
        next unless node.is_a?(BlockStatement)
        compiler.block_compilers << node.to_mom(compiler)
      end
      compiler
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def has_yield?
      each{|statement| return true if statement.is_a?(YieldStatement)}
      return false
    end

    def make_arg_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      type_hash[:implicit_block] = :Block if has_yield?
      Parfait::NamedList.type_for( type_hash )
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def #{name}(#{arg_str})" , @body.to_s(depth + 1) , "end")
    end

    private

    def make_frame
      nodes = []
      @body.each { |node| nodes << node }
      nodes.dup.each do |node|
        next unless node.is_a?(BlockStatement)
        node.each {|block_scope| nodes.delete(block_scope)}
      end
      type_hash = {}
      nodes.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        type_hash[node.name] = :Object
      end
      Parfait::NamedList.type_for( type_hash )
    end

  end
end
