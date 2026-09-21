class User < ApplicationRecord
  # Include default devise modules. Others available are:

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,  :confirmable, :lockable, :timeoutable, :trackable 

        enum :role, {
          admin: 0,
          employee: 1
        }
        
          has_many :projects,
           foreign_key: :owner_id,
           dependent: :destroy

  has_many :project_members,
           dependent: :destroy

  has_many :member_projects,
           through: :project_members,
           source: :project

  has_many :assigned_tasks,
           class_name: "Task",
           foreign_key: :assignee_id,
           dependent: :nullify

  validates :name, presence: true
end
