class CreateQuizzes < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.references :taker
      t.datetime :start_time
      t.datetime :end_time
      t.string :name

      t.timestamps
    end
    add_index :quizzes, :name
  end
end
