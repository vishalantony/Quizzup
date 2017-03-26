class CreateQuestionsQuizzesJoinTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :questions_quizzes, id: false do |t|
    	t.integer :question_id
    	t.integer :quiz_id
    end
  end
end
