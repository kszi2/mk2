class SetDefaultOrderingOnRatingPoint < ActiveRecord::Migration[8.1]
  def change
    change_column_null :rating_points, :ordering, true
  end
end
