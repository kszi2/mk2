class EnableCascadeDeletes < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :courseworks, :courses
    add_foreign_key :courseworks, :courses, on_delete: :cascade

    remove_foreign_key :course_types, :courses
    add_foreign_key :course_types, :courses, on_delete: :cascade

    remove_foreign_key :groups, :courses
    add_foreign_key :groups, :courses, on_delete: :cascade

    remove_foreign_key :templates, :courses
    add_foreign_key :templates, :courses, on_delete: :nullify

    remove_foreign_key :submissions, :courseworks
    add_foreign_key :submissions, :courseworks, on_delete: :cascade

    remove_foreign_key :rating_points, :courseworks
    add_foreign_key :rating_points, :courseworks, on_delete: :cascade

    remove_foreign_key :marked_points, :submissions
    add_foreign_key :marked_points, :submissions, on_delete: :cascade
  end
end
