class AddDisapprovedToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :disapproved, :boolean, default: false
  end
end
