class CommentSerializer < ActiveModel::Serializer
	cache key: 'comment'

  attributes :id, :content

  has_many :comments
end
