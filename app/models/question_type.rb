class QuestionType < ApplicationRecord
	has_many :questions, class_name: 'Question'
end
