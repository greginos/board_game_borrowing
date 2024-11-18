class CreateBorrowings < ActiveRecord::Migration[8.0]
  def change
    create_table :borrowings do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
