require 'spec_helper'

describe UserMailer do
  describe '#send_email_without_args' do
    it "should not raise NameError: undefined local variable or method `params' for ..." do
      expect{ UserMailer.send_email_without_args }.to_not raise_error
    end
  end
end
