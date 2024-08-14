class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.references :course, null: false, foreign_key: true
      t.string :name, null: false, limit: 32

      t.timestamps
    end

    add_index :groups, [:course_id, :name], unique: true
  end
end
