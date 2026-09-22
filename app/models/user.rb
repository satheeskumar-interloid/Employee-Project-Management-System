class User < ApplicationRecord
  # Include default devise modules. Others available are:

  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
           :confirmable, :lockable, :timeoutable, :trackable

        enum :role, {
          admin: 0,
          employee: 1
        }
end
