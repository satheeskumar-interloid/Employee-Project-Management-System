class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = policy_scope(Task).includes(:project, :assignee)

    if params[:search].present?
      @tasks = @tasks.where("title LIKE ?", "%#{params[:search]}%")
    end

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

    project = @projects.find(@task.project_id)

    authorize @task

    if @task.save
      TaskCreatedJob.perform_later(@task.id)
      redirect_to @task, notice: "Task created successfully."
    else
      render :new, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "You are not authorized to create a task for this project."
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

    if @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully."
    else
    redirect_to task_path(@task), alert: "Task could not be deleted."
    end
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
      :project_id,
      :assignee_id,
      attachments: []
    )
  end
end
