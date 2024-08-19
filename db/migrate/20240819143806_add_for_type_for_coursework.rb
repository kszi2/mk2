class AddForTypeForCoursework < ActiveRecord::Migration[7.1]
  def change
    add_reference :courseworks, :for_type, foreign_key: { to_table: :course_types }
  end
end
