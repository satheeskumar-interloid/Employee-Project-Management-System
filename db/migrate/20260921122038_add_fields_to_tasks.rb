class AddFieldsToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :title, :string
    add_column :tasks, :description, :text
    add_column :tasks, :priority, :integer
    add_column :tasks, :status, :integer
    add_column :tasks, :due_date, :date

    add_reference :tasks, :project, null: false, foreign_key: true
    add_reference :tasks, :assignee,
                  null: false,
                  foreign_key: { to_table: :users }
  end
end