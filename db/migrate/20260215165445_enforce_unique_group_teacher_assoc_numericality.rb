class EnforceUniqueGroupTeacherAssocNumericality < ActiveRecord::Migration[8.1]
  def up
    # Remove all existing multiples in the table. There is no information
    # in ordering, so any one of them will be kept from those with non-1
    # multiplicity. This is fine.
    execute <<~SQL.squish
      DELETE
      FROM groups_teachers
      WHERE CTID NOT IN (SELECT any_value(CTID)
                         FROM groups_teachers
                         GROUP BY group_id, user_id)
    SQL

    add_index :groups_teachers, [ :group_id, :user_id ], unique: true
  end

  def down
    remove_index :groups_teachers, [ :group_id, :user_id ]
  end
end
