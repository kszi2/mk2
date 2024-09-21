class CreateFreeDays < ActiveRecord::Migration[7.1]
  def change
    create_table :free_days do |t|
      t.string :name, null: false, limit: 64
      t.date :from_day, null: false
      t.date :to_day

      t.timestamps
    end
  end
end
