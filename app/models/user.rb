# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  extend Enumerize
  rolify
  attr_accessor :role_input

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ############## Callbacks #################
  before_create :assign_role

  ############## Validations #################
  validates_presence_of :username
  validates_presence_of :role_input, on: :create
  validates_uniqueness_of :username, :email

  enumerize :role_input, in: {member: 0, admin: 1}, scope: true

  def assign_role
    if self.role_input && !self.has_role?(self.role_input)
      self.add_role role_input
    end
  end
end
