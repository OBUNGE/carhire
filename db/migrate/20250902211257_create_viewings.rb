class CreateViewings < ActiveRecord::Migration[8.0]
  def change
    create_table :viewings do |t|
      t.references :booking, null: false, foreign_key: true
      t.datetime :scheduled_date
      t.text :notes

      t.timestamps
    end
  end
end
