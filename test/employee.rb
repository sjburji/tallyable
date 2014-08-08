require 'tallyable/acts_as_tallyable'

class Employee
  include Tallyable::ActsAsTallyable

  acts_as_tallyable "http://example.com"
end
