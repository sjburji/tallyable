require 'test_helper'

class TallyableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Tallyable
  end
end
