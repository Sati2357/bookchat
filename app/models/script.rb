class Script < ApplicationRecord

	def character
		return Character.find_by(id: self.character_id)
	end

end
