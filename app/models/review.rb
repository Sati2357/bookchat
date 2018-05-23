class Review < ApplicationRecord

	def review_user
		return User.find_by(id: self.user_id)
	end

end
