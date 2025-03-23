class AddStatusToBorrowings < ActiveRecord::Migration[8.0]
  def change
    add_column :borrowings, :status, :integer
  end
end
