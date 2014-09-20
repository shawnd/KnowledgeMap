class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.int :ID
      t.String :Node

      t.timestamps
    end
  end
end
