class ChangeLikeFieldInQus < ActiveRecord::Migration
  def up
    remove_column :qus, :likes
    add_column :qus, :like, :integer	
  end

  def down
  end
end
