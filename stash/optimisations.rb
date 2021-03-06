module Risc
  # Passes, or BlockPasses, could have been procs that just get each block passed.
  # Instead they are proper objects in case they want to save state.
  # The idea is 
  # - reduce noise in the main code by having this code seperately (aspect/concern style)
  # - abstract the iteration
  # - allow not yet written code to hook in
  
  class RemoveStubs
    def run block
      block.codes.dup.each_with_index do |kode , index|
        next unless kode.is_a? StackInstruction
        if kode.registers.empty?
          block.codes.delete(kode) 
          puts "deleted stack instruction in #{b.name}"
        end
      end
    end
  end

  # Operators eg a + b , must assign their result somewhere and as such create temporary variables.
  # but if code is c = a + b , the generated instructions would be more like tmp = a + b ; c = tmp
  # SO if there is an move instruction just after a logic instruction where the result of the logic
  # instruction is moved straight away, we can undo that mess and remove one instruction.
  class LogicMoveReduction
    def run block
      org = block.codes.dup
      org.each_with_index do |kode , index|
        n = org[index+1]
        next if n.nil?
        next unless kode.is_a? LogicInstruction
        next unless n.is_a? MoveInstruction
        # specific arm instructions, don't optimize as don't know what the extra mean
        # small todo. This does not catch condition_code that are not :al
        next if (n.attributes.length > 3) or (kode.attributes.length > 3)
        if kode.result == n.from
          puts "Logic reduction #{kode} removes #{n}"
          kode.result = n.to
          block.codes.delete(n)
        end
      end
    end
  end

  # Sometimes there are double moves ie mov a, b and mov b , c . We reduce that to move a , c 
  # (but don't check if that improves register allocation. Yet ?) 
  class MoveMoveReduction
    def run block
      org = block.codes.dup
      org.each_with_index do |kode , index|
        n = org[index+1]
        next if n.nil?
        next unless kode.is_a? MoveInstruction
        next unless n.is_a? MoveInstruction
        # specific arm instructions, don't optimize as don't know what the extra mean
        # small todo. This does not catch condition_code that are not :al
        next if (n.attributes.length > 3) or (kode.attributes.length > 3)
        if kode.to == n.from
          puts "Move reduction #{kode}: removes #{n} "
          kode.to = n.to
          block.codes.delete(n)
        end
      end
    end
  end

  #As the name says, remove no-ops. Currently mov x , x supported
  class NoopReduction
    def run block
      block.codes.dup.each_with_index do |kode , index|
        next unless kode.is_a? MoveInstruction
        # specific arm instructions, don't optimize as don't know what the extra mean
        # small todo. This does not catch condition_code that are not :al
        next if (kode.attributes.length > 3)
        if kode.to == kode.from
          block.codes.delete(kode) 
          puts "deleted noop move in #{block.name} #{kode}"
        end
      end
    end
  end
end
