class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_token, :string, index: true, unique: true, default: ""
  end
end
