class List < ApplicationRecord
  ############ Assocciations ############
	belongs_to :owner, class_name: 'User'
	has_and_belongs_to_many :users

  ############## Validations #################
	validates_presence_of :title

	def assign_member(user_id)
		user = User.find_by(id: user_id)
		if user && user != self.owner
			self.users << user
		else
			return nil
		end
	end

	def unassign_member(user_id)
		user = User.find_by(id: user_id)
		if user && self.users.include?(user)
			self.users.delete(user)
		else
			return nil
		end
	end
end
