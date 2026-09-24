class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User"

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

  validate :end_date_not_before_project_start

  has_many_attached :attachments

  private

  def end_date_not_before_project_start
    return if end_date.blank?
    return if project.blank?
    return if project.start_date.blank?

    if end_date < project.start_date
      errors.add(:end_date, "cannot be before project start date")
    end
  end
end
