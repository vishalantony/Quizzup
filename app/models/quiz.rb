class Quiz < ApplicationRecord
  #belongs_to :taker, class_name: 'User', foreign_key: 'id'
  #Q_TYPES = {'MCQ' => 1, 'Subjective' => 2}

  belongs_to :taker, :class_name => 'User'


  has_many :quiz_question_relationships, class_name: 'QuizQuestion',
  										 foreign_key: 'quiz_id',
  										 dependent: :destroy
  has_many :questions, through: :quiz_question_relationships

  validates :taker_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_must_be_before_end_time

  scope :score, -> (quiz) { QuizQuestion.where(quiz_id: quiz.id).sum(:marks) } 

  private

	def start_time_must_be_before_end_time
	    errors.add(:start_time, "must be before end time") unless
	        start_time < end_time
	end 

end
