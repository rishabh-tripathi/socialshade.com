class CreateAns < ActiveRecord::Migration
  def change
    create_table :ans do |t|
      t.integer :question_id
      t.string :value
      t.string :ip
      t.string :req_details

      t.timestamps
    end
  end
end
