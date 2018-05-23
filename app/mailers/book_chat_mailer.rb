class BookChatMailer < ApplicationMailer

	def send_customer_question_our(email,subject,message,our)
  		@our = our
 		@email = email
		@subject = subject
		@message = message
    		mail to:      "Receivingbox@medicihiroba.com",
         		subject: '顧客からの問い合わせ【BookChat】'
        end

end
