class CreateTopicRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_relationships do |t|
      t.integer :parent_id
      t.integer :subtopic_id

      t.timestamps
    end
    add_index :topic_relationships, [:parent_id, :subtopic_id], unique: true
    add_index :topic_relationships, [:parent_id]
  end
end
