class ProjectCreatedJob < ApplicationJob
  queue_as :default

  def perform(project_id)
    project = Project.find(project_id)
    recipients = []
    if project.members.exists?
      recipients = project.members.pluck(:email)
    end
    recipients << project.owner.email
    recipients.compact.uniq.each do |email|
      ProjectMailer.project_created(project, email).deliver_now
    end
  end
end