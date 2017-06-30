# Project Model
class Project
    include Mongoid::Document

    field :lastname, type: String
    field :firstname, type: String
    field :email, type: String

    validates :lastname, presence: true
    validates :firstname, presence: true
    validates :email, presence: true

    scope :lastname, -> (lastname) { where(lastname: /^#{lastname}/) }
    scope :firstname, -> (firstname) { where(firstname: /^#{firstname}/) }
    scope :email, -> (email) { where(email: email) }
end

# Serializers
class ProjectSerializer
    def initialize(project)
        @project = project
    end

    def as_json(*)
        data = {
            id:@project.id.to_s,
            lastname:@project.lastname.to_s,
            firstname:@project.firstname.to_s,
            email:@project.email.to_s
        }
        data[:errors] = @project.errors if@project.errors.any?
        data
    end
end