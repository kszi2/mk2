class ProperlyConnectGroupsStudenbts < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :groups_students, :students, on_delete: :cascade
    add_foreign_key :groups_students, :groups, on_delete: :cascade
  end
end
