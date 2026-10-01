class ProjectsController < ApplicationController
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

    @project.assign_attributes(project_attributes) 
    remove_attachments 
    attach_new_files 
    if @project.save
      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @project

    if @project.destroy
      redirect_to projects_path, notice: "Project deleted successfully."
    else
      redirect_to @project, alert: "Project could not be deleted."
    end
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
    params.require(:project).permit( :name, :description, :status, :start_date, :end_date, member_ids: [], attachments: [] )
  end

  def project_attributes 
    params.require(:project).permit( :name, :description, :status, :start_date, :end_date, member_ids: []  ) 
  end 

  def attach_new_files 
    files = params.dig(:project, :attachments) 
    files = Array(files).reject(&:blank?) 
    return if files.empty? 
    @project.attachments.attach(files) 
  end

  def remove_attachments 
    attachment_ids = params.dig(:project, :remove_attachment_ids) 
    attachment_ids = Array(attachment_ids).reject(&:blank?) 
    attachment_ids.each do |attachment_id| 
      attachment = @project.attachments.find_by(id: attachment_id) 
      attachment&.purge 
    end 
  end
end
