module Mom

  # A Label is the only legal target for a branch (in Mom, in Risc a BinaryCode is ok too)
  #
  # In the dynamic view (runtime) where the instructions form a graph,
  # branches fan out, Labels collect. In other words a branch is the place where
  # several roads lead off, and a Label where several roads arrive.
  #
  # A Label has a name which is mainly used for debugging.
  #
  # A Mom::Label converts one2one to a Risc::Label. So in a way it could not be more
  # simple.
  # Alas, since almost by definition several roads lead to this label, all those
  # several converted instructions must also point to the identical label on the
  # risc level.
  #
  # This is achieved by caching the created Risc::Label in an instance variable.
  # All branches that lead to this label can thus safely call the to_risc and
  # whoever calls first triggers the labels creation, but all get the same label.
  #
  # Off course some specific place still has to be responsible for actually
  # adding the label to the instruction list (usually an if/while)

  class Label < Instruction
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def to_s
      "Label: #{name}"
    end

    # generate the risc label lazily
    def risc_label(comiler)
      @risc_label ||= Risc.label(self,name)
      comiler.add_constant(@risc_label.address)
      @risc_label
    end

    # add the risc_label to the compiler (instruction flow)
    # should only be called once
    def to_risc(compiler)
      compiler.add_code( risc_label(compiler) )
    end
  end
end
