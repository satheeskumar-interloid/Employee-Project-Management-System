class TaskCreatedJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)

    TaskMailer.task_created( task, task.assignee.email ).deliver_now
  end
end
