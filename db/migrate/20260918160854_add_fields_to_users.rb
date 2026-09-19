class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false , default: 1
    add_column :users, :role, :integer
  end
end
