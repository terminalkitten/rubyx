require_relative "../helper"

module Risc
  class TestBuilderBoot < MiniTest::Test

    def setup
      Risc.machine.boot
      init = Parfait.object_space.get_init
      @builder = Risc::MethodCompiler.new( init ).builder
    end
    def test_has_build
      assert @builder.respond_to?(:build)
    end
    def test_has_attribute
      assert_nil @builder.built
    end
    def test_alloc_space
      reg = @builder.space
      assert_equal RiscValue , reg.class
      assert_equal :Space , reg.type
    end
    def test_next_message
      reg = @builder.next_message
      assert_equal :r1 , reg.symbol
      assert_equal :Message , reg.type
    end
    def test_message
      reg = @builder.message
      assert_equal :r0 , reg.symbol
      assert_equal :Message , reg.type
    end
    def test_returns_built
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 }
      assert_equal Transfer , built.class
    end
    def test_returns_two
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 ; space << r1}
      assert_equal Transfer , built.next.class
    end
    def test_returns_slot
      r2 = RiscValue.new(:r2 , :Message)
      r2.builder = @builder
      built = @builder.build{ r2 << space[:first_message] }
      assert_equal SlotToReg , built.class
      assert_equal :r1 , built.array.symbol
    end
    def test_returns_slot_reverse
      r2 = RiscValue.new(:r2 , :Message)
      r2.builder = @builder
      built = @builder.build{ r2 << space[:first_message] }
      assert_equal SlotToReg , built.class
      assert_equal :r1 , built.array.symbol
    end
    def test_reuses_names
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 ; space << r1}
      assert_equal built.to.symbol , built.next.to.symbol
    end
    def test_uses_message_as_message
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ message[:receiver] << r1}
      assert_equal RegToSlot , built.class
      assert_equal :r0 , built.array.symbol
    end
    def test_label
      label = @builder.exit_label
      assert_equal Label , label.class
      assert label.name.index("exit")
    end
    def test_two_label
      label1 = @builder.exit_label
      label2 = @builder.exit_label
      assert_equal label1 , label2
    end
  end
end
