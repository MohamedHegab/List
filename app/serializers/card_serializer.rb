class CardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_one :owner
  belongs_to :list
  has_many :comments

  def comments
    object.comments.first(3)
  end
end
