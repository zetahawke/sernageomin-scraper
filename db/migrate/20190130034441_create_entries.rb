class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.string :national_rol
      t.string :concession_name
      t.string :titular_name
      t.string :titular_dni
      t.string :detail_link
      t.string :region
      t.string :province
      t.string :commune
      t.string :belogings
      t.string :hectares
      t.string :rol_situation
      t.string :payment

      t.timestamps
    end
  end
end
