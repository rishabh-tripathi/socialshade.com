class AddUnlikeToQu < ActiveRecord::Migration
  def change
    add_column :qus, :unlike, :integer
  end
end
