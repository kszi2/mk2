class CreateRatingStyles < ActiveRecord::Migration[7.1]
  def change
    create_table :rating_styles do |t|
      t.string :name, null: false, limit: 64

      t.timestamps
    end
  end
end
