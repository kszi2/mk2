class LengthenRatingNameToUndefChars < ActiveRecord::Migration[7.1]
  def change
    change_column :rating_points, :name, :string
  end
end
