class AddIpFieldstoQu < ActiveRecord::Migration
  def up
    add_column :qus, :ip, :string 
    add_column :ques_views, :ip, :string
    add_column :qus, :expire, :integer 	
  end

  def down
  end
end
