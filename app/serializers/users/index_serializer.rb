class Users::IndexSerializer < UserSerializer
  attributes :id, :email, :username, :role
end
