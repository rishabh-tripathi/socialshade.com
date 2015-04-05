class AddExpiredOnQus < ActiveRecord::Migration
  def up
    add_column :qus, :expired, :integer
  end

  def down
  end
end
