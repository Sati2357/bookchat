class Comment < ApplicationRecord

	def comment_user
		return User.find_by(id: self.user_id)
	end
	
	def comment_like
		return Like.find_by(comment_id: self.id)
	end
	
	def comment_book
		return Book.find_by(id: self.book_id)
	end

	def comment_chat
		return Chat.find_by(book_id: self.book_id, chapter_id: self.chapter_id)
	end
end
