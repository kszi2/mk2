class MakeRatingsStyleNameUniq < ActiveRecord::Migration[7.1]
  def change
    add_index :rating_styles, :name, unique: true
  end
end
