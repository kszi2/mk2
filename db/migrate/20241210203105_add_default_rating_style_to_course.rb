class AddDefaultRatingStyleToCourse < ActiveRecord::Migration[7.1]
  def change
    add_reference :courses, :default_rating_style, null: true, foreign_key: { to_table: :rating_styles }
  end
end
