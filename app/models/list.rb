class List < ApplicationRecord
  ############ Assocciations ############
	belongs_to :owner, class_name: 'User'

  ############## Validations #################
	validates_presence_of :title
	
end
