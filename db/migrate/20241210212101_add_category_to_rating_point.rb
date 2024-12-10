class AddCategoryToRatingPoint < ActiveRecord::Migration[7.1]
  def change
    add_column :rating_points, :category, :string, limit: 32
  end
end
