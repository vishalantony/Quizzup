class AddDraftToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :draft, :boolean, default: true
  end
end
