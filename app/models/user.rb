class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
         # :trackable

  validates :username,
            :presence => true,
            :uniqueness => true
  validates :password,
            :confirmation => true
  validates :password_confirmation,
            :presence => true
  validates :admin,
            :inclusion => { :in => [true, false] }
end
