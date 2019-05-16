class User < ApplicationRecord
  attr_reader :password

  validates :username, :session_token, :cheers, :password_digest, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :goals

  has_many :comments_from_users, 
    as: :commentable,
    class_name: 'Comment'

  has_many :comments

  has_many :commented_goals,
    through: :comments,
    source: :commentable,
    source_type: 'Goal'

  has_many :commented_users,
    through: :comments,
    source: :commentable,
    source_type: 'User'

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def cheer(goal)
    return unless self.cheers > 0
    self.cheers -= 1
    goal.cheers += 1
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(username, pw)
    user = User.find_by_username(username)
    user && user.is_password?(pw) ? user : nil
  end
end
