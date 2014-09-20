class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :ID
      t.integer :PARENT_ENTRY_ID
      t.integer :CHILD_ENTRY_ID
      t.stringhttps :TYPE

      t.timestamps
    end
  end
end
