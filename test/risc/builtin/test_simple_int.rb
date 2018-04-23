require_relative "helper"

module Risc
  module Builtin
    class SimpleInt < BuiltinTest

      def test_add
        run_input "5 + 5"
        assert_equal Parfait::Integer , get_return.class
        assert_equal 10 , get_return.value
      end
      def test_minus
        run_input "5 - 5"
        assert_equal 0 , get_return.value
      end
      def test_minus_neg
        run_input "5 - 15"
        assert_equal -10 , get_return.value
      end
      def test_rshift
        run_input "#{2**8} >> 3"
        assert_equal 2**5 , get_return.value
      end
      def test_lshift
        run_input "#{2**8} << 3"
        assert_equal 2**11 , get_return.value
      end
      def test_div10
        run_input "45.div10"
        assert_equal 4 , get_return.value
      end
      def test_div4
        run_input "45.div4"
        assert_equal 11 , get_return.value
      end
      def test_mult
        run_input "4 * 4"
        assert_equal 16 , get_return.value
      end
      def test_smaller_true
        run_input "4 < 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_smaller_false
        run_input "6 < 5"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_larger_true
        run_input "5 > 4"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_larger_false
        run_input "5 > 6"
        assert_equal Parfait::FalseClass , get_return.class
      end
    end
  end
end
