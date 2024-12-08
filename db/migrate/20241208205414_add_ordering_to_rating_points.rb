class AddOrderingToRatingPoints < ActiveRecord::Migration[7.1]
  def up
    add_column :rating_points, :ordering, :integer
    add_index :rating_points, [:coursework_id, :ordering], unique: true

    execute <<-SQL
      BEGIN TRANSACTION;
      LOCK TABLE rating_points IN EXCLUSIVE MODE;
        WITH def_ordering AS ( SELECT CTID
                                    , RANK() OVER (PARTITION BY coursework_id ORDER BY created_at) "order"
                                 FROM rating_points
                             )
      UPDATE rating_points rp
         SET ordering = d."order"
        FROM def_ordering d
       WHERE rp.CTID = d.CTID;
      COMMIT;
    SQL

    # Need to do this before adding a trigger to it. After it cannot be altered.
    change_column :rating_points, :ordering, :integer, null: false

    execute <<-SQL
      CREATE FUNCTION trf_patch_ordering_on_insert() RETURNS TRIGGER
          RETURNS NULL ON NULL INPUT
          PARALLEL UNSAFE
          LANGUAGE plpgsql
      AS
      $$
      BEGIN
          NEW.ordering = ( SELECT MAX(rp.ordering) + 1
                             FROM rating_points rp
                            WHERE rp.coursework_id = NEW.coursework_id
                         );
          RETURN NEW;
      END
      $$;

      CREATE TRIGGER tr_patch_ordering_on_insert
          BEFORE INSERT
          ON rating_points
          FOR EACH ROW
          WHEN ( NEW.ordering IS NULL )
      EXECUTE FUNCTION trf_patch_ordering_on_insert();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS tr_patch_ordering_on_insert ON rating_points;
      DROP FUNCTION IF EXISTS trf_patch_ordering_on_insert();
    SQL

    remove_index :rating_points, [:coursework_id, :ordering]
    remove_column :rating_points, :ordering
  end
end
