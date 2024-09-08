class CreateMarkingNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :marking_notes do |t|
      t.integer :points_cost
      t.string :reason
      t.boolean :fixed
      t.references :marked_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
