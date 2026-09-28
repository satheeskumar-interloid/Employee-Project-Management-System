class TaskDeadlineReminderJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.current

    Task.where.not(status: :completed).where.not(end_date: nil).find_each do |task|
      if task.end_date == today + 1.day
        send_deadline_reminder(task)
      elsif task.end_date <= today
        send_overdue_reminder(task)
      end
    end
  end

  private

  def send_deadline_reminder(task)
    TaskMailer.deadline_tomorrow( task, task.assignee.email ).deliver_now
  end

  def send_overdue_reminder(task)
    TaskMailer.task_overdue( task, task.assignee.email ).deliver_now
  end
end
