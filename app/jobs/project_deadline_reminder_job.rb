class ProjectDeadlineReminderJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.current

    Project
      .where.not(status: :completed).where.not(end_date: nil).find_each do |project|
      if project.end_date == today + 1.day
        send_deadline_reminder(project)
      elsif project.end_date <= today
        send_overdue_reminder(project)
      end
    end
  end

  private

  def send_deadline_reminder(project)
    recipients(project).each do |email|
      ProjectMailer.deadline_tomorrow(project, email).deliver_now
    end
  end

  def send_overdue_reminder(project)
    recipients(project).each do |email|
      ProjectMailer.project_overdue(project, email).deliver_now
    end
  end

  def recipients(project)
    emails = []
    if project.members.exists?
      emails = project.members.pluck(:email)
    end
    emails << project.owner.email if project.owner&.email.present?
    emails.compact.uniq
  end
end