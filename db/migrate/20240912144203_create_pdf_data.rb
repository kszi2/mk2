class CreatePdfData < ActiveRecord::Migration[7.1]
  def change
    create_table :pdf_data do |t|

      t.timestamps
    end
  end
end
