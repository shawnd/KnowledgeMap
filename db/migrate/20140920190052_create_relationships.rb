class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.int :ID
      t.int :Parent_Entry_ID
      t.int :Child_Entry_ID
      t.int :Type_ID

      t.timestamps
    end
  end
end
