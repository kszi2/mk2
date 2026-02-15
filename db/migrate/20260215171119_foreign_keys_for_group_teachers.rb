class ForeignKeysForGroupTeachers < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :groups_teachers, :groups, column: :group_id
    add_foreign_key :groups_teachers, :users, column: :user_id
  end
end
