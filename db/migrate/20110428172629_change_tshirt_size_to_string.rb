class ChangeTshirtSizeToString < ActiveRecord::Migration
  def self.up
    change_column(:registrations, :tshirt_size, :string, :limit => 2)
    sizes = { '1'=>'PP', '2'=>'P', '3'=>'M', '4'=>'G', '5'=>'GG', '6'=>'XG' }
    Registration.all.each do |r|
       r.tshirt_size = sizes[r.tshirt_size]
       r.save
    end
  end

  def self.down
    railse 'cannot down'
  end
end
