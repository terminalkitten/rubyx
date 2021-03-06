require_relative "helper"

module Risc
  class TestWhileCmp < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(5 > 0) ; @a = true; end"
      @expect = [Label, LoadConstant, LoadConstant, SlotToReg, SlotToReg,
                 RegToSlot, RegToSlot, RegToSlot, RegToSlot, LoadConstant,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
                 FunctionCall, Label, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
                 LoadConstant, OperatorInstruction, IsZero, LoadConstant, SlotToReg,
                 RegToSlot, Branch, Label]
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end
    def test_label
      assert_equal Risc::Label , produce_body.class
    end
    def test_int_load_5
      produced = produce_body
      load = produced.next(9)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 5 , load.constant.value
    end
    def test_int_load_0
      produced = produce_body
      load = produced.next(12)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 0 , load.constant.value
    end
    def test_false_check
      produced = produce_body
      assert_equal  Risc::IsZero , produced.next(29).class
      assert produced.next(29).label.name.start_with?("merge_label") , produced.next(29).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Risc::LoadConstant , produced.next(30).class
      assert_equal Parfait::NilClass , produced.next(30).constant.class
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Risc::Branch , produced.next(36).class
      assert_equal produced , produced.next(36).label
    end

  end
end
