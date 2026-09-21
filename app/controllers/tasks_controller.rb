class TasksController < ApplicationController

  before_action :authenticate_user!

  before_action :set_task,
                only: [:show, :edit, :update, :destroy]

 def index
  @tasks = policy_scope(Task)

  if params[:search].present?
    @tasks = @tasks.where(
      "title LIKE ?",
      "%#{params[:search]}%"
    )
  end

  if params[:status].present?
    @tasks = @tasks.where(
      status: params[:status]
    )
  end

  if params[:priority].present?
    @tasks = @tasks.where(
      priority: params[:priority]
    )
  end
end

  def show
    authorize @task
  end

def new
  @task = Task.new
  @projects = policy_scope(Project)
  @employees = User.employee
  authorize @task
end

  def create
    @task = Task.new(task_params)

    authorize @task

    if @task.save
      redirect_to @task,
                  notice: "Task created successfully."
    else
      render :new,
             status: :unprocessable_entity
    end
  end

 def edit
  @projects = policy_scope(Project)
  @employees = User.employee
  authorize @task
end

  def update
    authorize @task

    if @task.update(task_params)
      redirect_to @task,
                  notice: "Task updated successfully."
    else
      render :edit,
             status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task

    @task.destroy

    redirect_to tasks_path,
                notice: "Task deleted successfully."
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
      :due_date,
      :project_id,
      :assignee_id,
      :attachment
    )
  end
end