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

  test '#send_email_with_keyreq' do
    assert_equal 'Action Args!!!', UserMailer.send_email_with_keyreq(subject: 'Action Args!!!').subject
  end

  test '#send_email_with_hash with an empty Hash' do
    assert_equal 'Action Args!!! {}', UserMailer.send_email_with_hash('Action Args!!!', {}).subject
  end

  test '#send_email_with_hash with a non-empty Hash' do
    assert_equal "Action Args!!! #{{cc: 'cc@example.com'}.inspect}", UserMailer.send_email_with_hash('Action Args!!!', {cc: 'cc@example.com'}).subject
  end

  test '#send_email_with_hash_and_key with a Hash and a keyword argument' do
    assert_equal "Hello #{{cc: 'cc@example.com'}.inspect}", UserMailer.send_email_with_hash_and_key({cc: 'cc@example.com'}, subject: 'Hello').subject
  end

  test '#send_email_with_hash_and_key with a Hash only' do
    assert_equal "Action Args!!! #{{cc: 'cc@example.com'}.inspect}", UserMailer.send_email_with_hash_and_key({cc: 'cc@example.com'}).subject
  end
end
