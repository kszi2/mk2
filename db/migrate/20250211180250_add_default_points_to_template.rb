class AddDefaultPointsToTemplate < ActiveRecord::Migration[8.0]
  def change
    add_column :templates, :cost, :integer, null: true
  end
end
