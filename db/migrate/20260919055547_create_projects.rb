class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
