class AddCommentsToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :comments, :text
  end
end
