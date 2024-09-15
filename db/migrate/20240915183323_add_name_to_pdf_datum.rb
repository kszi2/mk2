class AddNameToPdfDatum < ActiveRecord::Migration[7.1]
  def change
    add_column :pdf_data, :name, :string, limit: 255
  end
end
