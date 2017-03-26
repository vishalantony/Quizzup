class AddApprovedToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :approved, :boolean, default: false
  end
end
