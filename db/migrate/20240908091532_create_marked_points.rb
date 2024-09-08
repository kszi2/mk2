class CreateMarkedPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :marked_points do |t|
      t.references :submission, null: false, foreign_key: true
      t.references :rating_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
