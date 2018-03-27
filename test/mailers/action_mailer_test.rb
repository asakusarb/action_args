# frozen_string_literal: true
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test '#send_email_without_args' do
    #it should not raise NameError: undefined local variable or method `params' for ...
    assert UserMailer.send_email_without_args
  end

  test '#send_email_with_optional_args' do
    #it should not raise NoMethodError: undefined method for nil:NilClass
    assert UserMailer.send_email_with_optional_args
  end
end
