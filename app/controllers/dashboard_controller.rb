class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      # Admin sees overall system counts
      @projects_count = Project.count
      @tasks_count = Task.count
      @employees_count = User.employee.count
    else
      # Employee sees their own work
      @projects_count = current_user.member_projects.count
      @tasks_count = current_user.assigned_tasks.count
      @employees_count = nil
    end
  end
end