class ChangeUidFieldInQus < ActiveRecord::Migration
  def up
    change_column :qus, :uid, :string
  end

  def down
  end
end
