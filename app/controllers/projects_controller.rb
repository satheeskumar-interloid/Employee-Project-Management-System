class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    @projects = policy_scope(Project)
  end

  def show
    authorize @project
  end

  def new
    @project = current_user.projects.build
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)

    authorize @project

    if @project.save
      ProjectCreatedJob.perform_later(@project.id)
      redirect_to @project, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @project

    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully."
  end

  def members
    @project = Project.find(params[:id])

    authorize @project, :show?

    render json: @project.members.select(:id, :name)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :description,
      :status,
      :start_date,
      :end_date,
      member_ids: [],
      attachments: []
    )
  end
end
