class TopicsController < ApplicationController
  def show
  	@topic = Topic.find(params[:id])
  	@parent = @topic.parent
  	@subtopics = @topic.subtopics
    @questions = @topic.questions.paginate(page: params[:page])
    @local_leaderboard = Quiz.joins(:questions).where('topic_id == (?)', @topic.id).group(:taker).order('sum_marks DESC').limit(10).sum(:marks)
  end

  def index
  	if logged_in?
	  	@topics = current_user.topics_not_followed.paginate(page: params[:page])
  	else
  		@topics = Topic.all.paginate(page: params[:page])
  	end
  end

  def new
    @topic = Topic.new
    @current_topics = Topic.all
    @topic.subtopic_relationship = TopicRelationship.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save 
      flash[:info] = "Topic created"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  
  def topic_params
    if params[:topic][:subtopic_relationship_attributes][:parent_id].blank?
      params.require(:topic).permit(:name, :about, :image)
    else
      params.require(:topic).permit(:name, :about, {:subtopic_relationship_attributes =>  [:parent_id]}, :image)
    end
  end
  
end


