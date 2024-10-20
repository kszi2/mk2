class LengthenCourseworkNameTo255Chars < ActiveRecord::Migration[7.1]
  def change
    change_column :courseworks, :name, :string, limit: 255
  end
end
