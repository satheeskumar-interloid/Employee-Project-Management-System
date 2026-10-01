class RemoveDueDateFromTasks < ActiveRecord::Migration[8.1]
  def change
    remove_column :tasks, :due_date, :date
  end
end
