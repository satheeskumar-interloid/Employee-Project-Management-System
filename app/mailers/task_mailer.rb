class TaskMailer < ApplicationMailer
  def task_created(task, recipient)
    @task = task
    @project = task.project
    @recipient = recipient

    mail(
      to: @recipient,
      subject: "New Task Assigned: #{@task.title}"
    )
  end

  def deadline_tomorrow(task, recipient)
    @task = task
    @project = task.project
    @recipient = recipient

    mail(
      to: @recipient,
      subject: "Task Deadline Tomorrow: #{@task.title}"
    )
  end

  def task_overdue(task, recipient)
    @task = task
    @project = task.project
    @recipient = recipient

    @overdue_days =
      (Date.current - @task.due_date).to_i

    mail(
      to: @recipient,
      subject: "Task Overdue: #{@task.title}"
    )
  end
end
