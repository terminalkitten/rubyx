require "support/hash_attributes"
module Vm
  
  #currently just holding the program in here so we can have global access
  class Context
    # Make hash attributes to object attributes
    include Support::HashAttributes
    
    def initialize program
      @attributes = {}
      @attributes[:program] = program
    end
    attr_reader :attributes
  end
end
