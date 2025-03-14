class AddPreferredTimeZoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :preferred_time_zone, :string
  end
end
