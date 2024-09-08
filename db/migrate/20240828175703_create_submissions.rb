class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.references :student, null: false, foreign_key: true
      t.references :coursework, null: false, foreign_key: true

      t.timestamps
    end
  end
end
