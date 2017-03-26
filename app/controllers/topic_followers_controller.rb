class TopicFollowersController < ApplicationController
	def create
		@topic = Topic.find(params[:followed_topic_id])
		current_user.follow_topic(@topic)

		respond_to do |format|
			format.html { redirect_to @topic }
			format.js
		end
	end

	def destroy
		@topic = TopicFollower.find(params[:id]).followed_topic
		current_user.unfollow_topic(@topic)
		
		respond_to do |format|
		    format.html { redirect_to @topic }
		   	format.js
		end
	end
end
