class SubmissionAddGroupId < ActiveRecord::Migration[8.0]
  def up
    add_column :submissions, :group_id, :bigint
    add_foreign_key :submissions, :groups

    execute <<~SQL.squish
      UPDATE submissions
         SET group_id = g.id
        FROM students st
           , groups_students gs
           , groups g
       WHERE g.id = gs.group_id
         AND st.id = gs.student_id
         AND submissions.student_id = st.id
    SQL
  end

  def down
    remove_foreign_key :submissions, :groups
    remove_column :submissions, :group_id
  end
end
