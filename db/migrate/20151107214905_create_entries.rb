class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title, index: true
      t.text :description
      t.string :street_name, index: true
      t.string :street_number, index: true
      t.string :postal_code, index: true, null: false
      t.string :city, index: true, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end

    add_index :entries, [:latitude, :longitude]

    execute "
      CREATE INDEX ON entries USING gin(to_tsvector('english', title));
      CREATE INDEX ON entries USING gin(to_tsvector('english', description));
      CREATE INDEX ON entries USING gin(to_tsvector('english', street_name));
      CREATE INDEX ON entries USING gin(to_tsvector('english', street_number));
      CREATE INDEX ON entries USING gin(to_tsvector('english', postal_code));
      CREATE INDEX ON entries USING gin(to_tsvector('english', city));"
  end
end
