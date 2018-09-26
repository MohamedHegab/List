class Card < ApplicationRecord
	############ Assocciations ############
	belongs_to :owner, class_name: 'User'
	belongs_to :list

  ############## Validations #################
	validates_presence_of :title
end
