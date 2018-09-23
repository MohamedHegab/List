class User < ApplicationRecord
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

  enum role_input: [:member, :admin]

  def assign_role
    if self.role_input && !self.has_role?(self.role_input)
      self.add_role role_input
    end
  end
end
