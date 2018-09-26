class Card < ApplicationRecord
	############ Assocciations ############
	belongs_to :owner, class_name: 'User'
	belongs_to :list
	has_many :comments, as: :commentable, dependent: :destroy

  ############## Validations #################
	validates_presence_of :title

	scope :by_comments, -> { left_joins(:comments).group(:id).order(Arel.sql('COUNT(comments.id) DESC')).limit(10) }
end
