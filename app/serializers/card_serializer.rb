class CardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_one :owner
  belongs_to :list
end
