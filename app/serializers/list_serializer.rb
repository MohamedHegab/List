class ListSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_one :owner
  has_many :users
end
