class Book < ApplicationRecord

	def book_user
		return User.find_by(id: self.user_id)
	end

	def book_reviewAll
		return Review.where(book_id: self.id)
	end	

end
