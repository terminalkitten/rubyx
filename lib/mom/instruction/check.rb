module Mom

  # A base class for conditions in MOM
  # Checks (if in code, compare in assm) jump or not, depending
  # The logic we choose is closer to the code logic (the asm is reversed)
  # When we write an if, the true is the next code, so the Check logic is
  # that if the check passes, no jump happens
  # This means you need to pass the false label, where to jump to if the
  # check does not pass
  # Note: In assembler a branch on 0 does just that, it branches if the condition
  #       is met. This means that the asm implementation is somewhat the reverse
  #       of the Mom names. But it's easier to understand (imho)
  class Check < Instruction
    attr_reader :false_jump
    def initialize(false_jump)
      @false_jump = false_jump
      raise "Jump target must be a label #{false_jump}" unless false_jump.is_a?(Label)
    end
  end

end
