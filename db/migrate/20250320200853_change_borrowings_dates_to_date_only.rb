class ChangeBorrowingsDatesToDateOnly < ActiveRecord::Migration[8.0]
  def change
    change_column :borrowings, :start_date, :date
    change_column :borrowings, :end_date, :date
  end
end
