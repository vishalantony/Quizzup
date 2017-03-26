class QuizzesController < ApplicationController

  DURATIONS = [10,20,30,40]
  Q_LIMITS = [5,10,15,20]
  Q_MAP = {
            DURATIONS[0] => Q_LIMITS[0],
            DURATIONS[1] => Q_LIMITS[1],
            DURATIONS[2] => Q_LIMITS[2],
            DURATIONS[3] => Q_LIMITS[3],
          }
  

  before_action :set_params, only: [:create]
  before_action :find_questions, only: [:create]
  before_action :logged_in_user, only: [:new, :show, :create, :results, :submit, :index]
  before_action :quiz_submitted, only: [:submit, :show]
  before_action :quiz_completed, only: [:submit, :show]
  before_action :quiz_taken, only: [:results]
  before_action :correct_taker, only: [:submit, :show, :results]

  before_action :get_quiz, only: [:show, :submit, :results]

  after_action :submit_and_save_quiz, only: [:submit]
  

  def new
    @quiz_name = "Quiz #{current_user.taken_quizzes.length + 1}"
  	@quiz = Quiz.new(name: @quiz_name)
  	@followed_topics = current_user.followed_topics
  	@durations = DURATIONS
  end

  def index
    @quizzes = current_user.taken_quizzes.paginate(page: params[:page])
  end

  def global_leaderboard 
    @questions_by_taker = Quiz.joins(:questions).group(:taker)
    @gl_leaderboard = @questions_by_taker.order('sum_marks DESC').sum(:marks)
    @quiz_count = @questions_by_taker.distinct.count(:quiz_id)
  end

  def show
    @questions = @quiz.questions
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      add_questions_to_quiz
      flash[:info] = "quiz created!"
      redirect_to @quiz
    else
      redirect_to root_url 
    end
  end


  def results
  end

  def submit
    @questions = @quiz.questions.preload(:choices)
    @qquestions = QuizQuestion.where(quiz_id: @quiz.id).preload(:question)
    @qquestions.each do |qq|
      qq.user_answer = params[:quiz][qq.question.id.to_s]
      qq.save
    end
    redirect_to "/quizzes/#{@quiz.id}/results"
  end

  private

  def submit_and_save_quiz
    @quiz.submitted = true
    @quiz.save
  end

  def get_quiz
    @quiz = Quiz.find(params[:quiz_id] || params[:id])
  end

  def correct_taker
    quiz = Quiz.find(params[:id] || params[:quiz_id])
    if current_user != quiz.taker
      flash[:danger] = 'Not your quiz'
      redirect_to root_path
    end
  end

  def quiz_submitted
    @quiz = Quiz.find(params[:id] || params[:quiz_id])
    if @quiz.submitted?
      flash[:danger] = 'You have already submitted this quiz'
      redirect_to action: 'results', id: @quiz.id
    end
  end

  def quiz_completed
    @quiz = Quiz.find(params[:id] || params[:quiz_id])
    if @quiz.end_time < Time.zone.now 
      flash[:danger] = "Time's up my friend."
      redirect_to action: 'results', id: @quiz.id
    end
  end

  def quiz_taken
    quiz = Quiz.find(params[:id])
    if not ((quiz.end_time < Time.zone.now) || (quiz.submitted?))
      flash[:danger] = "Can't view this page right now."
      redirect_to root_path
    end
  end

  def add_questions_to_quiz
    @quiz.questions << @questions
  end

  def quiz_params
    params.require(:quiz).permit(:name, :end_time, :start_time, :taker_id)
  end

  def set_params
    params[:quiz][:name] = "Quiz #{current_user.taken_quizzes.length + 1}"
    params[:quiz][:start_time] = Time.zone.now
    params[:quiz][:end_time] = params[:quiz][:start_time] + params[:quiz][:end_time].to_i.minutes
    params[:quiz][:taker_id] = current_user.id
  end

  def find_questions
    duration = time_diff_in_minutes(params[:quiz][:start_time], params[:quiz][:end_time])
    #binding.pry
    questions_needed = Q_MAP[duration]
    topics = params[:quiz][:questions]
    @questions = Question.possible_quiz_questions(topics, questions_needed, current_user)

    if @questions.blank? || @questions.length < questions_needed
      flash[:danger] = "Not enough questions!"
      redirect_to new_quiz_path
    end
  end

end