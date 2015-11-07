class ExtendUserAttributes < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string    :street_name
      t.string    :street_number
      t.string    :city
      t.string    :postal_code
      t.float     :latitude
      t.float     :longitude
    end

    add_index :users, [:latitude, :longitude]

    execute "
      CREATE INDEX ON users USING gin(to_tsvector('english', name));
      CREATE INDEX ON users USING gin(to_tsvector('english', street_name));
      CREATE INDEX ON users USING gin(to_tsvector('english', street_number));
      CREATE INDEX ON users USING gin(to_tsvector('english', postal_code));
      CREATE INDEX ON users USING gin(to_tsvector('english', city));"
  end

  def down
    change_table :users do |t|
      t.remove :street_name, :street_number, :postal_code, :city, :latitude, :longitude
    end

    remove_index :users, [:latitude, :longitude]
  end
end
