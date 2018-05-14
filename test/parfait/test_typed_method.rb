require_relative "helper"

module Parfait
  class TestMethod < ParfaitTest

    def setup
      super
      obj = Parfait.object_space.get_class_by_name(:Object).instance_type
      args = Parfait::Type.for_hash( obj.object_class , { bar: :Integer , foo: :Type})
      frame = Parfait::Type.for_hash( obj.object_class , { local_bar: :Integer , local_foo: :Type})
      @method = Parfait::TypedMethod.new( obj , :meth , args , frame)
    end

    def test_method_name
      assert_equal :meth , @method.name
    end

    def test_class_for
      assert_equal :Object , @method.for_type.object_class.name
    end

    def test_arg1
      assert_equal 2 , @method.arguments_length , @method.arguments_type.inspect
      assert_equal Symbol , @method.arguments_type.names.first.class
      assert_equal :bar , @method.argument_name(0)
    end

    def test_has_argument
      assert_equal 0 , @method.has_argument(:bar)
      assert_equal 1 , @method.has_argument(:foo)
    end

    def test_add_arg
      @method.add_argument(:foo2 , :Object)
      assert_equal 3 , @method.arguments_length
      assert_equal :foo2 , @method.argument_name(3)
      assert_equal :Object , @method.argument_type(3)
    end

    def test_get_arg_name1
      index = @method.has_argument(:bar)
      assert_equal 0 , index
      assert_equal :bar , @method.argument_name(index)
    end
    def test_get_arg_type1
      index = @method.has_argument(:bar)
      assert_equal :Integer , @method.argument_type(index)
    end
    def test_get_arg_name2
      index = @method.has_argument(:foo)
      assert_equal 1 , index
      assert_equal :foo , @method.argument_name(index)
    end
    def test_get_arg_type2
      index = @method.has_argument(:foo)
      assert_equal :Type , @method.argument_type(index)
    end

    def test_local1
      assert_equal 2 , @method.frame_length , @method.frame_type.inspect
      assert_equal Symbol , @method.frame_type.names.first.class
      assert_equal :local_bar , @method.locals_name(0)
    end

    def test_has_local
      assert_equal 0 , @method.has_local(:local_bar)
      assert_equal 1 , @method.has_local(:local_foo)
    end

    def test_add_local
      @method.add_local(:foo2 , :Object)
      assert_equal 3 , @method.frame_length
      assert_equal :foo2 , @method.locals_name(3)
      assert_equal :Object , @method.locals_type(3)
    end

    def test_get_locals_name1
      index = @method.has_local(:local_bar)
      assert_equal 0 , index
      assert_equal :local_bar , @method.locals_name(index)
    end
    def test_get_frame_type1
      index = @method.has_local(:local_bar)
      assert_equal :Integer , @method.locals_type(index)
    end
    def test_get_locals_name2
      index = @method.has_local(:local_foo)
      assert_equal 1 , index
      assert_equal :local_foo , @method.locals_name(index)
    end
    def test_get_frame_type2
      index = @method.has_local(:local_bar)
      assert_equal :Integer , @method.locals_type(index)
    end
    def test_created_with_binary
      assert @method.binary
    end
  end
end
