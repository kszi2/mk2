class AddRepetitionToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :first_date, :date, null: false
    add_column :groups, :repeat_times, :integer, null: false, default: 14
    add_column :groups, :day_difference, :integer, null: false, default: 7
  end
end
