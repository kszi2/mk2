class AddUniqueConstraintOnRatings < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE rating_points
          ADD CONSTRAINT uq_cw_order UNIQUE (coursework_id, ordering)
          DEFERRABLE INITIALLY DEFERRED;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE rating_points DROP CONSTRAINT uq_cw_order;
    SQL
  end
end
