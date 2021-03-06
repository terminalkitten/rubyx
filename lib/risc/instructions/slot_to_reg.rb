module Risc

  # SlotToReg moves data into a register from memory.
  # RegToSlot moves data into memory from a register.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of SlotToReg setting the value in the array.

  # btw: to move data between registers, use Transfer

  class SlotToReg < Getter

  end

  # Produce a SlotToReg instruction.
  # Array and to are registers
  # index may be a Symbol in which case is resolves with resolve_index.
  def self.slot_to_reg( source , array , index , to)
    raise "Not register #{array}" unless RegisterValue.look_like_reg(array)
    index = array.resolve_index(index) if index.is_a?(Symbol)
    SlotToReg.new( source , array , index , to)
  end
end
