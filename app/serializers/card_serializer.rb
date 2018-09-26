class CardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_one :owner
  has_one :list
end
