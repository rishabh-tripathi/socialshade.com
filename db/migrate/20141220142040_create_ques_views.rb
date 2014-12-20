class CreateQuesViews < ActiveRecord::Migration
  def change
    create_table :ques_views do |t|
      t.integer :qu_id
      t.string :uid
      t.integer :count

      t.timestamps
    end
  end
end
