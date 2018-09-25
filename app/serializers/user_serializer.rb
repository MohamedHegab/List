class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role, :auth_token
end
