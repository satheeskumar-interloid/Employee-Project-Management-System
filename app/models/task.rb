class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User"

  has_many_attached :attachments

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2,
    critical: 3
  }

  enum :status, {
    todo: 0,
    in_progress: 1,
    completed: 2
  }

  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :project, presence: true
  validates :assignee, presence: true


  validate :end_date_not_before_project_start
  validate :assignee_must_be_project_member
  validate :end_date_not_before_start_date



  private

  def end_date_not_before_project_start
    return if end_date.blank?
    return if project.blank?
    return if project.start_date.blank?

    if end_date < project.start_date
      errors.add(:end_date, "cannot be before project start date")
    end
  end

  def end_date_not_before_start_date
    return if start_date.blank?
    return if end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before task start date")
    end
  end

  def assignee_must_be_project_member
  return if assignee.blank? || project.blank?
  errors.add(:assignee, "must be a member of the project") unless project.members.exists?(assignee.id)
end

end
