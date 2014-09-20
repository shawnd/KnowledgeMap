class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :ID
      t.string :NODE

      t.timestamps
    end
  end
end
