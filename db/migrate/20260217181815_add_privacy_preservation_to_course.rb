class AddPrivacyPreservationToCourse < ActiveRecord::Migration[8.1]
  def up
    add_column :courses, :privacy_preserving, :boolean, default: true
    Course.update_all privacy_preserving: true
  end

  def down
    remove_column :courses, :privacy_preserving
  end
end
