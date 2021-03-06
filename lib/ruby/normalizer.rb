module Ruby
  module Normalizer
    # given a something, determine if it is a Name
    #
    # Return a Name, and a possible rest that has a hoisted part of the statement
    #
    # eg  if( @var % 5) is not normalized
    # but if(tmp_123) is with tmp_123 = @var % 5 hoisted above the if
    #
    # also constants count, though they may not be so useful in ifs, but returns
    def normalize_name( condition )
      if( condition.is_a?(ScopeStatement) and condition.single?)
        condition = condition.first
      end
      return [condition] if condition.is_a?(Variable) or condition.is_a?(Constant)
      local = "tmp_#{object_id}".to_sym
      assign = LocalAssignment.new( local , condition)
      [LocalVariable.new(local) , assign]
    end
  end
end
