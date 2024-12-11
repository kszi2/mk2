class UpdateOrderingTriggerToHandleNewCourseworks < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      DROP TRIGGER IF EXISTS tr_patch_ordering_on_insert ON rating_points;
      DROP FUNCTION IF EXISTS trf_patch_ordering_on_insert();
    SQL

    execute <<-SQL
      CREATE FUNCTION trf_patch_ordering_on_insert() RETURNS TRIGGER
          RETURNS NULL ON NULL INPUT
          PARALLEL UNSAFE
          LANGUAGE plpgsql
      AS
      $$
      BEGIN
          NEW.ordering = ( SELECT COALESCE(MAX(rp.ordering) + 1, 1)
                             FROM rating_points rp
                            WHERE rp.coursework_id = NEW.coursework_id
                         );
          RETURN NEW;
      END
      $$;
    SQL

    execute <<-SQL
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

    # old trigger from 20241208205414_add_ordering_to_rating_points.rb
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
    SQL

    execute <<-SQL
      CREATE TRIGGER tr_patch_ordering_on_insert
          BEFORE INSERT
          ON rating_points
          FOR EACH ROW
          WHEN ( NEW.ordering IS NULL )
      EXECUTE FUNCTION trf_patch_ordering_on_insert();
    SQL
  end
end
