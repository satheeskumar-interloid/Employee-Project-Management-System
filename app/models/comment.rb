class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validate :content_must_not_be_empty

  private

  def content_must_not_be_empty
    if content.blank?
      errors.add(:content, "can't be empty")
    end
  end
end
