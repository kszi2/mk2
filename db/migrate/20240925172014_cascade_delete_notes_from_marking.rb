class CascadeDeleteNotesFromMarking < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :marking_notes, :marked_points
    add_foreign_key :marking_notes, :marked_points, on_delete: :cascade
  end
end
