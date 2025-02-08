class AddJoinTableGroupsTeachers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :groups, :users, table_name: :groups_teachers
  end
end
