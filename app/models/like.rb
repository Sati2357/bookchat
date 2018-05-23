class Like < ApplicationRecord

	def like_author
		return User.find_by(id: self.author_id)
	end

end
