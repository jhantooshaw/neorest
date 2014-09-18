class CreateHappyHours < ActiveRecord::Migration
  def change
    create_table :happy_hours do |t|
      t.references     :location
      t.references     :outlet
      t.integer        :happy_hour_cd
      t.date           :start_date
      t.date           :end_date
      t.references     :combo_package
      t.timestamps
    end
    add_index :happy_hours, [:location_id, :outlet_id, :happy_hour_cd], name: 'by_loc_out_happy_hour', unique: true
    add_index :happy_hours, :combo_package_id
    add_index :happy_hours, :outlet_id
    add_index :happy_hours, :happy_hour_cd
  end
end