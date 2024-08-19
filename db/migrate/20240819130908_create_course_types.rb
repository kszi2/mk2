class CreateCourseTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :course_types do |t|
      t.string :name, null: false, limit: 32
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :groups, :course_type, foreign_key: true, index: true
  end
end
