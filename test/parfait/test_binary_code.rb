require_relative "helper"

module Parfait
  class TestBinaryCode < ParfaitTest

    def setup
      super
      @code = BinaryCode.new(10)
    end

    def test_class
      assert_equal :BinaryCode, @code.get_type.object_class.name
    end
    def test_var_names
      assert_equal List , @code.get_instance_variables.class
    end
    def test_var_names_length
      assert_equal 2 , @code.get_instance_variables.get_length
    end
    def test_var_next
      assert_equal :next , @code.get_instance_variables[1]
    end
    def test_next_nil
      assert_nil @code.next
    end
    def test_data_length
      assert_equal 13 , @code.data_length
    end
    def test_byte_length
      assert_equal 13*4 , @code.byte_length
    end
    def test_total_byte_length
      @code = BinaryCode.new(16)
      assert_equal 13*4*2 , @code.total_byte_length
    end
    def test_next_not_nil
      @code = BinaryCode.new(16)
      assert @code.next
      assert_nil @code.next.next
    end
    def test_set_char1
      assert @code.set_char(1 , 1)
    end
    def test_set_char51
      assert @code.set_char(51 , 1)
    end
    def test_set_char52_raises
      assert_raises {@code.set_char(52 , 1)}
    end
    def test_set_char56_double
      @code = BinaryCode.new(16)
      assert @code.set_char(56 , 120)
    end
    def test_nilled
      assert_equal 0 , @code.get_word(1)
      assert_equal 0 , @code.get_word(14)
    end
    def test_get_set_self
      @code.set_word(10,1)
      assert_equal 1 , @code.get_word(10)
    end
    def test_get_set_next
      @code = BinaryCode.new(20)
      @code.set_word(20,1)
      assert_equal 1 , @code.get_word(20)
    end
    def test_extend
      @code.extend_to(20)
      assert @code.next
      assert_nil @code.next.next
    end
    def test_auto_extend #extend by seting word
      assert_nil @code.next
      @code.set_word(20 , 1)
      assert @code.next
    end
    def test_extend_extended
      @code.extend_to(20)
      @code.extend_to(30)
      assert @code.next.next
      assert_nil @code.next.next.next
    end
    def test_each
      len = 0
      @code.each_word{ len += 1}
      assert_equal 13 , len
    end
    def test_each_set
      (1..13).each{|i| @code.set_word(i,i)}
      all = []
      @code.each_word{ |w| all << w}
      assert_equal 1 , all.first
      assert_equal 13 , all.last
    end
    def test_set_word
      assert_equal 1 , @code.set_word(1 , 1)
    end
    def test_get_word
      @code.set_word(1 , 1)
      assert_equal 1, @code.get_word(1)
    end
    def test_get_internal_word
      @code.set_word(1 , 1)
      assert_equal 1, @code.get_internal_word(@code.data_start + 1)
    end
    def test_has_each
      sum = 0
      @code.each{ sum += 1}
      assert_equal sum , 1
    end
  end
end
