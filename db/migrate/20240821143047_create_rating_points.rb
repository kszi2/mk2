class CreateRatingPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :rating_points do |t|
      t.string :name, null: false, limit: 32
      t.string :description
      t.integer :available_points, null: false, default: 0
      t.references :coursework, null: false, foreign_key: true

      t.timestamps
    end

    add_index :rating_points, [:coursework_id, :name], unique: true
  end
end
