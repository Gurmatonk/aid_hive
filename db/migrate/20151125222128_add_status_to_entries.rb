class AddStatusToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :status, :integer, null: false, default: 0, index: true
  end
end
