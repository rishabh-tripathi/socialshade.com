class CreateQus < ActiveRecord::Migration
  def change
    create_table :qus do |t|
      t.integer :uid
      t.text :text
      t.integer :type
      t.integer :views
      t.integer :likes
      t.integer :ans

      t.timestamps
    end
  end
end
