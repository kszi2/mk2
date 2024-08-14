class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name, null: false, index: { unique: true }, limit: 64
      t.references :course, null: true, foreign_key: true
      t.string :data, null: false

      t.timestamps
    end
  end
end
