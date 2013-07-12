require 'test_helper'

class ActsAsTallyableTest < Test::Unit::TestCase
	def test_a_staff_tallyable_attempts_tally_request
		response = Staff.tally_request(Rails.root.to_s + 
			"/app/views/staffs/employees.xml", 
			Settings.tally_host, 
			Settings.tally_port)
    assert_equal response.code, "200"
  end

  def test_a_staff_tallyable_returns_nil_for_invalid_file
		response = Staff.tally_request("",
			Settings.tally_host, 
			Settings.tally_port)
    assert_equal response, nil
  end

  def test_a_staff_tallyable_errors_on_an_invalid_connection
		response = Staff.tally_request(
			Rails.root.to_s + "/app/views/staffs/employees.xml",
			Settings.tally_host,
			25)
		assert_equal response, nil
  end

  def test_a_staff_tallyable_attempts_persist_on_a_valid_request
  	Staff.delete_all
		response = Staff.tally_persist_records(
			Rails.root.to_s + "/app/views/staffs/employees.xml",
			Settings.tally_host)
		assert_equal response, true
    assert Staff.count > 0
  end

  def test_a_staff_tallyable_returns_false_on_an_invalid_request
  	Staff.delete_all

		# attempt 1
		Staff.tally_persist_records(
			Rails.root.to_s + "/app/views/staffs/employees.xml",
			Settings.tally_host)
		staffs_count = Staff.count

		# attempt 2 : fail email uniqueness validation
		response = Staff.tally_persist_records(
			Rails.root.to_s + "/app/views/staffs/employees.xml",
			Settings.tally_host)
		assert_equal response, false
		assert_equal Staff.count, staffs_count
  end
end
