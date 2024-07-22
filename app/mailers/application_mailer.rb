# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sampleapp@example.com'
  layout 'mailer'
end
