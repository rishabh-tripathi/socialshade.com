class Fixcolumninqu < ActiveRecord::Migration
  def up
    rename_column :qus, :type, :qu_type
  end

  def down
  end
end
