class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :qu_id
      t.string :content
      t.integer :seq

      t.timestamps
    end
  end
end
