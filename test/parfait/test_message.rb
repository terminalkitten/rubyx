require_relative "helper"

module Parfait
  class TestMessage < ParfaitTest

    def setup
      super
      @mess = @space.get_next_for(:Message)
    end
    def test_length
      assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
    end
    def test_attribute_set
      @mess.set_receiver( 55 ) # 55 is not parfait, hance not actually allowed
      assert_equal 55 , @mess.receiver
    end
    def test_indexed
      assert_equal 8 , @mess.get_type.variable_index(:arguments)
    end
    def test_next_message
      assert_equal Message ,  @mess.next_message.class
    end
    def test_locals
      assert_equal NamedList , @mess.frame.class
    end
    def test_arguments
      assert_equal NamedList , @mess.arguments.class
    end
    def test_return_address
      assert_nil @mess.return_address
    end
    def test_return_value
      assert_nil @mess.return_value
    end
    def test_caller
      assert_nil @mess.caller
    end
    def test_method
      assert_nil @mess.method
    end
  end
end
