class RenameQuestionTypeToQuestionTypeId < ActiveRecord::Migration[5.0]
  def change
  	rename_column :questions, :question_type, :question_type_id
  end
end
