class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :parent
      t.integer :child
      t.string :type

      t.timestamps
    end
  end
end
