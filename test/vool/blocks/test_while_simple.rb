require_relative "helper"

module VoolBlocks
  class TestSimpleWhileMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Parfait.boot!
      @ins = compile_first_block( "while(@a) ; @a = 5 ; end")
    end

    def test_compiles_as_while
      assert_equal Label , @ins.class , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next.condition.class , @ins
    end
    def test_array
      check_array [Label, TruthCheck, SlotLoad, Jump, Label], @ins
    end
  end
end
