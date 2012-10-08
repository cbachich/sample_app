# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy

  before_save { self.email.downcase! }
  before_save :create_remember_token

  # Validate that a name is not blank and is no longer than50 characters
  validates :name, presence: true, length: { maximum: 50 }

  # Validate that an email address is not blank, contains a valid pattern, and 
  # is not already in the database
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } 
  
  #Validate the password is there and is at least 6 characters
  validates :password, length: { minimum: 6 } 
  validates :password_confirmation, presence: true

  # Everything below this private is only visibile to this user model
  private

    # Creates a remember token for the user (not a local variable)
    # Used to keep a user login active indefinitely after sign in
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
