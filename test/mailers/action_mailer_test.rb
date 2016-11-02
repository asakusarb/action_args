# frozen_string_literal: true
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test '#send_email_without_args' do
    #it should not raise NameError: undefined local variable or method `params' for ...
    assert UserMailer.send_email_without_args
  end
end
