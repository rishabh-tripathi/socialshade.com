class MakeExpireFieldDefaultQu < ActiveRecord::Migration
  def up
    change_column :qus, :expire, :integer, :default => 0
    change_column :qus, :expired, :integer, :default => 0
  end

  def down
  end
end
