class User < ApplicationRecord

  validates :email, {presence: true, uniqueness: true}
  validates :password, {presence: true}
  validates :user_name, {presence: true, uniqueness: true}
  has_secure_password

  def user_aozoraBooks 
  	return Book.where(user_id: self.id, finish: 2)
  end

end
