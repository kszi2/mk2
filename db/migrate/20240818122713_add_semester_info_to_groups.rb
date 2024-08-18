class AddSemesterInfoToGroups < ActiveRecord::Migration[7.1]
  def up
    add_column :groups, :year, :date, null: false, default: Date.today
    add_column :groups, :semester, :integer, null: false, default: 1

    remove_index :groups, [:course_id, :name], unique: true
    add_index :groups, [:course_id, :name, :year, :semester], unique: true
  end

  def down
    add_index :groups, [:course_id, :name], unique: true
    remove_index :groups, [:course_id, :name, :year, :semester], unique: true

    remove_column :groups, :year
    remove_column :groups, :semester
  end
end
