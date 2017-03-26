class QuizQuestion < ApplicationRecord
	belongs_to :question, class_name: 'Question'
	belongs_to :quiz, class_name: 'Quiz'
	attr_accessor :user_answer
	MARKS = {'mcq' => {true => 2, false => -1}, 'subjective' => {true => 2, false => 0}}
	#before_save 

	private 

	before_update  do
		self.marks = calculate_marks
		self.user_answer = user_answer
	end

	def calculate_marks
	    if user_answer.blank?
	      return 0
	  	end
	    
	    if self.question.typename == 'mcq'
	    	user_answer = self.question.answer
	    end
	    return MARKS[self.question.typename][user_answer == self.question.answer]
	end
end
