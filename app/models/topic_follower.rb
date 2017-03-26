class TopicFollower < ApplicationRecord
	belongs_to :follower, class_name: 'User'
	belongs_to :followed_topic, class_name: 'Topic'
end
