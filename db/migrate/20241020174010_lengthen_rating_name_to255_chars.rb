class LengthenRatingNameTo255Chars < ActiveRecord::Migration[7.1]
  def change
    change_column :rating_points, :name, :string, limit: 255
  end
end
