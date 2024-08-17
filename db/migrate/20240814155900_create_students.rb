class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :name, null: false, limit: 255
      t.string :neptun, null: false, limit: 6, index: { unique: true }

      t.timestamps
    end

    create_join_table :students, :groups
  end
end
