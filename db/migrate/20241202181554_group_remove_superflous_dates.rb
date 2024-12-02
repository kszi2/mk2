class GroupRemoveSuperflousDates < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :year
    remove_column :groups, :semester
  end
end
