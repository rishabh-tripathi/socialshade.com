class AddAreaFieldToQus < ActiveRecord::Migration
  def change
    add_column :qus, :country_code, :string      	
    add_column :qus, :country_name, :string      	
    add_column :qus, :region_code, :string      	
    add_column :qus, :region_name, :string      	
    add_column :qus, :city_name, :string      	
    add_column :qus, :latitude, :string      	
    add_column :qus, :longitude, :string      	
  end
end
