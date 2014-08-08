require 'test_helper'
require 'employee'

class ActsAsTallyableTest < Minitest::Test
  def employee_stub(port, stub_response)
    stub_request(:post, "http://example.com:#{ port }").
      with( body: File.read("lib/tallyable/employee_request.xml") ).
        to_return(stub_response)
  end

  def test_an_employee_tallyable_for_invalid_request
    employee_stub(9002, status: 500, body: "Internal Server Error", headers: {})

    result = Employee.employee_request
    assert_equal result, []
  end

  def test_an_employee_tallyable_on_a_valid_request
    employee_stub(9002, status: 200, 
      body: File.read("test/fixtures/employee_response.xml"), headers: {})

    result = Employee.employee_request
    assert_equal result.count, 3
  end

  def test_an_employee_tallyable_response_on_a_valid_request
    employee_stub(9002, status: 200, 
      body: File.read("test/fixtures/employee_response.xml"), headers: {})

    result = Employee.employee_request
    assert_equal result.first[:name], "test_employee_1"
    assert_equal result.first[:email], "test_employee_1@example.com"
    assert_equal result.first[:date_of_birth], '20-July-1970'
    assert_equal result.first[:gender], "Male"
    assert_equal result.first[:address], "Bangalore"
    assert_equal result.first[:phone], "1234567890"
  end
end
