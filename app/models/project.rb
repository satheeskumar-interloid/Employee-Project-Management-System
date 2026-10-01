class Project < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user
  has_many :tasks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_many_attached :attachments

  enum :status, {
    planning: 0,
    active: 1,
    completed: 2,
    archived: 3
  }

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :project_members, presence:true

  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
