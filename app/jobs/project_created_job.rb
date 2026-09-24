class ProjectCreatedJob < ApplicationJob
  queue_as :default

  def perform(project_id)
    project = Project.find(project_id)

    recipients = project.members.pluck(:email)

    recipients << project.owner.email

    recipients.uniq.each do |email|
      ProjectMailer.project_created(project, email).deliver_now
    end
  end
end
