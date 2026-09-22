class Task < ApplicationRecord
  belongs_to :project

  belongs_to :assignee,
             class_name: "User"

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
  validates :due_date, presence: true

  validate :due_date_not_before_project_start

  has_one_attached :attachment

  private

  def due_date_not_before_project_start
    return if due_date.blank?
    return if project.blank?
    return if project.start_date.blank?

    if due_date < project.start_date
      errors.add(
        :due_date,
        "cannot be before project start date"
      )
    end
  end
end
