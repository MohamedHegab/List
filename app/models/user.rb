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
  before_create :generate_authentication_token!

  ############ Assocciations ############
  has_many :lists, foreign_key: :owner_id, dependent: :destroy

  ############## Validations #################
  validates_presence_of :username
  validates_uniqueness_of :username, :auth_token
  validates :role, inclusion: { in: %w(member admin),
    message: "%{value}is not a valid role" }, on: :create

  enum role: {member: 0, admin: 1}

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end
