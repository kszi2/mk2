class CreateExpressions < ActiveRecord::Migration[8.0]
  def change
    create_table :expressions do |t|
      t.string :sexpr
      t.jsonb :parsed

      t.timestamps
    end
  end
end
