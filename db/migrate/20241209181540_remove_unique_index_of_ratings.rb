class RemoveUniqueIndexOfRatings < ActiveRecord::Migration[7.1]
  def up
    remove_index :rating_points, [:coursework_id, :ordering]
  end

  def down
    add_index :rating_points, [:coursework_id, :ordering], unique: true
  end
end
