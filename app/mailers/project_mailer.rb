class ProjectMailer < ApplicationMailer
  def project_created(project, recipient)
    @project = project
    @recipient = recipient

    mail( to: @recipient, subject: "New Project Assigned: #{@project.name}" )
  end

  def deadline_tomorrow(project, recipient)
    @project = project
    @recipient = recipient

    mail( to: @recipient, subject: "Project Deadline Tomorrow: #{@project.name}" )
  end

  def project_overdue(project, recipient)
    @project = project
    @recipient = recipient

    @overdue_days = (Date.current - @project.end_date).to_i

    mail( to: @recipient, subject: "Project Overdue: #{@project.name}" )
  end
end
