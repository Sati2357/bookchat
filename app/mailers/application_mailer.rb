class ApplicationMailer < ActionMailer::Base
  default from:     "sendingbox@medicihiroba.com",
          reply_to: "sendingbox@medicihiroba.com"
  layout 'mailer'
end
