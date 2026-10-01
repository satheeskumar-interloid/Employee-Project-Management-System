module TaskFilters
  extend ActiveSupport::Concern

  private

  def apply_task_filters(tasks)
    if params[:search].present?
      tasks = tasks.where("title LIKE ?", "%#{params[:search]}%")
    end

    if params[:project_id].present?
      tasks = tasks.where(project_id: params[:project_id])
    end

    if params[:status].present?
      tasks = tasks.where(status: params[:status])
    end

    if params[:priority].present?
      tasks = tasks.where(priority: params[:priority])
    end

    tasks
  end
end