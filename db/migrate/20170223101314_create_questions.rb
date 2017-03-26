class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :question
      t.integer :type
      t.string :answer
      t.references :topic, foreign_key: true
      t.references :creator
      t.timestamps
    end
  end
end
