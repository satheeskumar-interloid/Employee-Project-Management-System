class TasksController < ApplicationController
  include TaskFilters
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = policy_scope(Task).includes(:project, :assignee)
    @projects = policy_scope(Project).order(:name)
    @tasks = apply_task_filters(@tasks)
  end

  def show
    authorize @task
  end

  def new
    @task = Task.new
    load_form_data
  end

  def create
    @task = Task.new(task_params)

    if @task.invalid?
      load_form_data
      render :new, status: :unprocessable_entity
      return
    end

    authorize @task

    if @task.save
      TaskCreatedJob.perform_later(@task.id)
      redirect_to @task, notice: "Task created successfully."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "You are not authorized to create a task for this project."
  end

  def edit
    authorize @task
    load_form_data
  end

  def update
    authorize @task

    if @task.update(task_params)
      redirect_to @task, notice: "Task updated successfully."
    else
      load_form_data
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

  def load_form_data
    @projects  = policy_scope(Project)
    @assignees = @task.project ? @task.project.members : User.none
  end

  def task_params
    params.require(:task).permit( :title, :description, :priority, :status, :start_date, :end_date, :project_id, :assignee_id, attachments: [] )
  end
end
