require_relative "helper"

module Risc
  class TestWhile < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(@a) ; arg = 5 end"
      @expect = [Label, SlotToReg, SlotToReg, LoadConstant, OperatorInstruction ,
                 IsNotZero, LoadConstant, OperatorInstruction, IsNotZero, LoadConstant ,
                 SlotToReg, RegToSlot, Unconditional, Label]
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end

    def test_false_load
      produced = produce_body
      assert_equal Mom::FalseConstant , produced.next(3).constant.class
    end
    def test_false_check
      produced = produce_body
      assert_equal produced.next(13) , produced.next(5).label
    end
    def test_nil_load
      produced = produce_body
      assert_equal Mom::NilConstant , produced.next(6).constant.class
    end
    def test_nil_check
      produced = produce_body
      assert_equal produced.next(13) , produced.next(8).label
    end

    def test_merge_label
      produced = produce_body
      assert produced.next(13).name.start_with?("merge_label")
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal produced , produced.next(12).label
    end
  end
end