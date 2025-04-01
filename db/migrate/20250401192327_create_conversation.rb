class CreateConversation < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
        t.bigint :user1_id, null: false
        t.bigint :user2_id, null: false
        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
        t.index [ :user1_id, :user2_id ], unique: true, name: "index_conversations_on_user1_id_and_user2_id"
    end

    change_table :messages do |t|
      t.remove :friendship_id
      t.references :conversation, null: false, foreign_key: true
    end
  end
end
