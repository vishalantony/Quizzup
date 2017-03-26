class CreateTopicFollowers < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_followers do |t|
      t.integer :followed_topic_id 
      t.integer :follower_id

      t.timestamps
    end
    add_index :topic_followers, [:followed_topic_id, :follower_id], unique: true
    add_index :topic_followers, [:follower_id]
    add_index :topic_followers, [:followed_topic_id]
  end
end
