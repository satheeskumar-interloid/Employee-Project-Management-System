class ChangeUserFields < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :name, :string

    change_column :users, :role, :integer, null: false, default: 1
  end
end