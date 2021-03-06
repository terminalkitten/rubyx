
module Vool
  class IfStatement < Statement

    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end

    def to_mom( compiler )
      if_false ? full_if(compiler) : simple_if(compiler)
    end

    def simple_if(compiler)
      true_label  = Mom::Label.new( "true_label_#{object_id.to_s(16)}")
      merge_label = Mom::Label.new( "merge_label_#{object_id.to_s(16)}")

      head = Mom::TruthCheck.new(condition.slot_definition(compiler) , merge_label)
      head << true_label
      head << if_true.to_mom(compiler)
      head << merge_label
    end

    def full_if(compiler)
      true_label  = Mom::Label.new( "true_label_#{object_id.to_s(16)}")
      false_label = Mom::Label.new( "false_label_#{object_id.to_s(16)}")
      merge_label = Mom::Label.new( "merge_label_#{object_id.to_s(16)}")

      head = Mom::TruthCheck.new(condition.slot_definition(compiler) , false_label)
      head << true_label
      head << if_true.to_mom(compiler)
      head << Mom::Jump.new(merge_label)
      head << false_label
      head << if_false.to_mom(compiler)
      head << merge_label
    end

    def each(&block)
      block.call(condition)
      @if_true.each(&block)
      @if_false.each(&block) if @if_false
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

    def to_s(depth = 0)
      parts = ["if (#{@condition})" , @body.to_s(depth + 1) ]
      parts += ["else" ,  "@if_false.to_s(depth + 1)"] if(@false)
      parts << "end"
      at_depth(depth , *parts )
    end
  end
end
