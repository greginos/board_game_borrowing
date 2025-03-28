class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.timestamps
      t.references :from, null: false, foreign_key: { to_table: :users }
      t.references :to, null: false, foreign_key: { to_table: :users }
      t.references :friendship, null: false, foreign_key: true
      t.text :text_ciphertext, null: false  # Stocke le texte encrypté
    end
  end
end
