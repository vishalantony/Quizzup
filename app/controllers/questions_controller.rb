class QuestionsController < ApplicationController
	#before_action :creat_updt_checks, only: [:create]
	before_action :is_admin?, only: [:new_approval, :approve]
	before_action :approved_or_disapproved?, only: [:approve]
	before_action :get_question, only: [:show, :new_approval, :approve]
	before_action :get_question_and_set_default_values, only: [:create]

	before_action :logged_in_user, only: [:show, :pending_approvals, :my_questions, :new, :new_approval, :approve, :create]

	def show
		@choices = @question.choices
	end

	def pending_approvals
		@questions = Question.questions_pending_approval.paginate(page: params[:page])
	end

	def my_questions
		@questions = current_user.submitted_questions.paginate(page: params[:page])
	end

	def new_approval
		@qtypes = QuestionType.all
		@topics = Topic.all
		@controller = 'questions'
		@action = 'approve'
	end

	def approve
	    if @question.update_attributes(question_params)
	      flash[:success] = (@question.disapproved?)? "Question disapproved" : "Question approved"
	      redirect_to pending_approvals_path
	    else
	    	render 'edit'
	    end
	end

	def new
		@question = Question.new
		init_other_vars @question
	end

	def create
		if @question.save
			flash[:info] = (@question.approved?) ? 'Question submitted' : 'Question has been submitted for approval' 
			redirect_to root_path
		else
			# render new question form with errors retaining values already entered.
			init_other_vars @question
			render 'new'
		end
	end

	private

	def get_question
		@question = Question.find(params[:id])
	end

	def get_question_and_set_default_values
		@question = current_user.submitted_questions.build(question_params)
		@question.draft = false;
		if not current_user.admin?
			@question.approved = false;
			@question.disapproved = false;
		end
	end

	def init_other_vars(question) 
		@topics = Topic.all
		@qtypes = QuestionType.all
		n_choices = 0
		question.choices.each do n_choices += 1 end
		(4-n_choices).times do question.choices.build end
	end

	def is_admin?
		if !current_user.admin?
			flash[:danger] = "You aren't an admin!"
			redirect_to root_url
		end
	end

	def approved_or_disapproved?
		if params[:question][:approved] == '0' && params[:question][:disapproved] == '0'
			flash[:danger] = 'Please approve or disapprove this question.'
			redirect_to "/questions/#{params[:id]}/approve"
		end
	end	


	# accession format : USER_ALLOWED_PARAMS[admin?][question type]
	def question_params
		typename = QuestionType.find(params[:question][:question_type_id]).typename
		{
			true => {       
				'mcq' => params.require(:question).permit(:question, :question_type_id, {:choices_attributes =>  [:id, :choice]} , :answer, :topic_id, :approved, :disapproved),
				'subjective' => params.require(:question).permit(:question, :question_type_id, :answer, :topic_id, :approved, :disapproved)
			},
			false => {      
				'mcq' => params.require(:question).permit(:question, :question_type_id, {:choices_attributes =>  [:id, :choice]} , :answer, :topic_id),
				'subjective' => params.require(:question).permit(:question, :question_type_id, :answer, :topic_id)
			}
		}[current_user.admin?][typename]
	end

end


