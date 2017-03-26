class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w_]+[\w+\-.]+@[a-z\d]+([a-z\d\-.])*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  # a user follows many topics.
  has_many :topic_follow_relationships, class_name: 'TopicFollower',
                                        foreign_key: 'follower_id',
                                        dependent: :destroy
  has_many :followed_topics, through: :topic_follow_relationships

  #submitted questions
  has_many :submitted_questions, class_name: 'Question', foreign_key: 'creator_id'

  #quizzes taken
  has_many :taken_quizzes, class_name: 'Quiz', foreign_key: 'taker_id'

  has_many :attempted_questions, :through => :taken_quizzes, source: :questions



  def follows_any_topic?
    ! self.followed_topics.empty?
  end

  def follows_how_many_topic
    self.followed_topics.count
  end

  def follow_topic(topic)
    self.followed_topics << topic
  end

  def unfollow_topic(topic) 
    self.followed_topics.delete(topic)
  end

  def following_topic?(topic) 
    self.followed_topics.include?(topic)
  end

  def topics_not_followed
    Topic.where("id NOT IN (:followed_topics_ids)", 
      followed_topics_ids: (followed_topic_ids.empty?) ? '' : followed_topic_ids )
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    return SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end 