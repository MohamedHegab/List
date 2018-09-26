class Comment < ApplicationRecord
	############ Assocciations ############
	belongs_to :commentable, polymorphic: true, optional: true
	has_many :comments, as: :commentable, dependent: :destroy
	belongs_to :user

  ############## Validations #################
  validates_presence_of :content
end
