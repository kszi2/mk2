class CreateCourseworks < ActiveRecord::Migration[7.1]
  def change
    create_table :courseworks do |t|
      t.references :course, null: false, foreign_key: true
      t.string :name, null: false, limit: 32
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :courseworks, [:course_id, :name], unique: true
  end
end
