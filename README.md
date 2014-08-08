## Tallyable

* Basic Tally ERP.9 integration using xml api
* The motivation is to provide a "Get Started" framework for Tally integration. This has to be essentially extended as per custom requirements.
* This requires Tally ERP.9 to be running with the Company selected from the Tally interface
* To be used as a guide to develope integration capabilities for your rails application with Tally ERP.9
* Authentication is interestingly kept open with default configuration, for the xml interface
  * This is because Authentication is not yet configurable in Tally ERP.9 remote user using xml api interface
  * Allows only Tally .NET user's Application login for now
* TDL (Tally Domain Language) was found to be the most relevant and easy to use for integration purposes
* Refer test cases for usage
  * To run test cases use `rake test`
* Disclaimer
  * Author does not endorse TALLY, nor has any links with TALLY trademark or brand

## Installation

Add this line to your application's Gemfile:

    gem 'tallyable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tallyable

## Usage

    require 'tallyable'

    class Employee
      acts_as_tallyable "http://example.com", 9002

      self.class.employee_request
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
