class ChangeNoteTypeFromIntToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :marking_notes, :points_cost, :decimal, precision: 8, scale: 1
  end
end
