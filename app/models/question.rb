class Question < ApplicationRecord
  belongs_to :topic

  belongs_to :question_type, class_name: 'QuestionType'
  delegate :typename, to: :question_type

  has_many :choices, :dependent => :destroy, inverse_of: :question
  accepts_nested_attributes_for :choices, allow_destroy: true

  belongs_to :creator, :class_name => 'User'

  has_many :quiz_question_relationships, class_name: 'QuizQuestion',
  										 foreign_key: 'question_id',
  										 dependent: :destroy
  has_many :quizzes, through: :quiz_question_relationships

  #scope :pending_approvals, where(draft: false && approved: false && disapproved: false)
  scope :questions_pending_approval, -> {
                                   where('draft == (:false) and 
                                   approved == (:false) and 
                                   disapproved == (:false)', false: false) 
                               }

  

  scope :possible_quiz_questions, -> (selected_topics, questions_needed, current_user) {
                                        where('draft == (:false) and 
                                                approved == (:true) and 
                                                disapproved == (:false) and 
                                                creator_id != (:user_id) and 
                                                id NOT IN (:taken_questions) and 
                                                topic_id IN (:selected_topics)',
                                          true: true,
                                          false: false,
                                          user_id: current_user.id,
                                          taken_questions: (current_user.attempted_question_ids.blank?)? '' : (current_user.attempted_question_ids),
                                          selected_topics: (selected_topics.blank?)? '' : selected_topics
                                        ).order('random()').limit(questions_needed)
                                      }

  validates :topic_id, presence: true
  validates :answer, presence: true
  validates :question_type, presence: true
  validates :question, presence: true, length: { maximum: 1024 }
  validates :creator_id, presence: true

=begin
  delegates :name, to: :question_type :

  def name
    question_type.name
  end

  question.name 


  def q_type
    self.question_type
  end

=end
end
