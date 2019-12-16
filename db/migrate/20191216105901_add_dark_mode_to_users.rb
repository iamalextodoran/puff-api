class AddDarkModeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dark_mode, :boolean
  end
end
