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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ############## Callbacks #################

  ############## Validations #################
  validates_presence_of :username
  validates_presence_of :role, on: :create
  validates_uniqueness_of :username
  validates :role, inclusion: { in: %w(member admin),
    message: "%{value} is not a valid role" }

  enum role: {member: 0, admin: 1}
end
