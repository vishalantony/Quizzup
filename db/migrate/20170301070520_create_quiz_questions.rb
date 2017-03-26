class CreateQuizQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :quiz_questions do |t|
      t.integer :marks
      t.string :user_answer
      t.integer :quiz_id
      t.integer :question_id

      t.timestamps
    end
    add_index :quiz_questions, [:quiz_id, :question_id], unique: true
    add_index :quiz_questions, [:quiz_id]
    add_index :quiz_questions, [:question_id]
  end
end
