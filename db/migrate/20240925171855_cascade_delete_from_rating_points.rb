class CascadeDeleteFromRatingPoints < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :marked_points, :rating_points
    add_foreign_key :marked_points, :rating_points, on_delete: :cascade
  end
end
