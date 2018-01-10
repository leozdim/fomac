class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :person, optional: true 
  has_many :projects
  accepts_nested_attributes_for :person
  ROLES = [:admin, :creator, :reviewer, :judge].freeze

  def admin?
    role==:admin 
  end

  def reviewer?
    role==:reviewer 
  end

  def judge?
    role==:judge 
  end

  def creator?
    role==:creator 
  end

  def role
    read_attribute(:role).to_sym
  end

  def role=(new_status)
    write_attribute :role, new_status.to_s
  end

  def any_project?
    projects.any?
  end

  def current_project
    projects.first
  end

  def full_name
    "#{last_name}#{second_last_name}#{first_name}"
  end


  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml

    super && account_active?
  end

end
