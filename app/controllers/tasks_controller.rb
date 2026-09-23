class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = policy_scope(Task).includes(:project, :assignee)

    if params[:search].present?
      @tasks = @tasks.where("title LIKE ?", "%#{params[:search]}%")
    end

    @tasks = Task.includes(:project, :assignee)
    if params[:project_id].present?
      @tasks = @tasks.where(project_id: params[:project_id])
    end

    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end

    if params[:priority].present?
      @tasks = @tasks.where(priority: params[:priority])
    end
  end

  def show
    authorize @task
  end

  def new
    @task = Task.new
    @projects = policy_scope(Project)
  end

  def create
    @task = Task.new(task_params)
    @projects = policy_scope(Project)
    if @task.invalid?
      flash.now[:alert] = "All fields are required."

      render :new, status: :unprocessable_entity
      return
    end

    begin
      project = @projects.find(@task.project_id)

      authorize @task

      unless project.members.exists?(@task.assignee_id)
        @task.errors.add(:assignee, "must be a member of the selected project")
        @projects = policy_scope(Project)
        render :new, status: :unprocessable_entity
        return
      end

      if @task.save
        redirect_to @task, notice: "Task created successfully."
      else
        render :new, status: :unprocessable_entity
      end

    rescue ActiveRecord::RecordNotFound
      redirect_to tasks_path, alert: "You are not authorized to create a task for this project."
    end
  end

  def edit
    @projects = policy_scope(Project)
    authorize @task
  end

  def update
    authorize @task

    if @task.update(task_params)
      redirect_to @task, notice: "Task updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task

    @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully."
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :priority,
      :status,
      :start_date,
      :end_date,
      :due_date,
      :project_id,
      :assignee_id,
      attachments: []
    )
  end
end
