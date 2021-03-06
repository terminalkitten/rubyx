require_relative "helper"

module Risc
  class TestPositionTranslated < MiniTest::Test
    def setup
      Parfait.boot!
      Risc.boot!
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
    end

    def test_bin_propagates_existing
      @binary.extend_to(16)
      CodeListener.init( @binary , :interpreter).set(0)
      assert_equal @binary.padded_length , Position.get(@binary.next_code).at
    end
    def test_bin_propagates_after
      CodeListener.init( @binary , :interpreter).set(0)
      @binary.extend_to(16)
      assert_equal @binary.padded_length , Position.get(@binary.next_code).at
    end
  end
end
