class Addvisitas < ActiveRecord::Migration[5.1]
  def change
  	add_column :questions, :visitas, :integer, :default => 0
  end
end
