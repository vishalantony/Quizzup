class AddSubmittedToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :submitted, :boolean, default: false
  end
end
