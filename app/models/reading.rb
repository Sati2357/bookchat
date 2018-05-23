class Reading < ApplicationRecord

	def reading_book 
		return Book.find_by(id: self.book_id)
	end

	def reading_reviewAll
		return Review.where(book_id: self.book_id)
	end

end
