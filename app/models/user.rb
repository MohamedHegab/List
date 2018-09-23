class User < ApplicationRecord
  attr_accessor :role_input

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ############## Validations #################
  validates_presence_of :username
  validates_presence_of :role_input, on: :create
  validates_uniqueness_of :username, :email

  enum role_input: [:member, :admin]
end
