class Topic < ApplicationRecord
	has_many :parenting_relationships, class_name: 'TopicRelationship',
									  foreign_key: 'parent_id',
									  dependent: :destroy,
									  inverse_of: :parent

	has_many :subtopics, through: :parenting_relationships


	has_one :subtopic_relationship, class_name: 'TopicRelationship',
									foreign_key: 'subtopic_id',
									dependent: :destroy,
									inverse_of: :subtopic

	has_one :parent, through: :subtopic_relationship

	accepts_nested_attributes_for :subtopic_relationship, allow_destroy: true


	# a topic can be followed by one or more users.
	has_many :user_followers_relationships, class_name: 'TopicFollower',
											foreign_key: 'followed_topic_id',
											dependent: :destroy
	has_many :followers, through: :user_followers_relationships

	has_many :questions, class_name: 'Question'

	mount_uploader :image, PictureUploader

	validate :image_size

	def has_parent?
		!self.parent.nil?
	end

	def has_subtopics?
		!self.subtopics.empty?
	end

	def has_followers?
		!self.followers.empty?
	end

	def how_many_followers
		self.followers.count
	end

	def has_questions?
		!self.questions.empty?
	end

	def how_many_questions
		self.questions.count
	end

	def image_size
		if image.size > 1.megabytes
			errors.add(:picture, 'Should be less than 1 MB')
		end
	end
end
