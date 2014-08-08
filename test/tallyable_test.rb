require 'test_helper'

class TallyableTest < Minitest::Test
  def test_truth
    assert_kind_of Module, Tallyable
  end
end
