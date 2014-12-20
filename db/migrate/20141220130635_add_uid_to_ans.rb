class AddUidToAns < ActiveRecord::Migration
  def change
    add_column :ans, :uid, :string
  end
end
