require_relative "helper"

module Vool
  class TestIvarMom < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ins = compile_first_method( "@a = 5")
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_self
      assert_equal :receiver , @ins.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @ins.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @ins.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
  end
end
