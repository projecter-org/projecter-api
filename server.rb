require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

Mongoid.load! "mongoid.config"

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

namespace '/api/v1' do

    before do
        content_type 'application/json'
    end

    helpers do
        def base_url
            @base_url ||= "#
            {request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
        end

        def json_params
            begin
                JSON.parse(request.body.read)
            rescue
                halt 400, { message:'Invalid JSON' }.to_json
            end
        end
    end

    def project
        @project ||= Project.where(id: params[:id]).first
    end

    def halt_if_not_found!
        halt(404, { message:'Project not found' }.to_json) unless project
    end

    def serialize(project)
        ProjectSerializer.new(project).to_json
    end

    get '/projects' do
        projects = Project.all

        # TODO -> Add case insensitvie
        [:lastname, :firstname, :email].each do |filter|
            projects = projects.send(filter, params[filter]) if params[filter]
        end

        projects.map { |project| ProjectSerializer.new(project) }.to_json
    end

    get '/projects/:id' do |id|
        halt_if_not_found!
        ProjectSerializer.new(project).to_json
    end

    post '/projects' do
        project = Project.new(json_params)
        halt 422, serialize(project) unless project.save

        response.headers['Location'] = "#{base_url}/api/v1/projects/#{project.id}"
        status 201
    end

    patch '/projects/:id' do |id|
        halt_if_not_found!
        halt 422, serialize(project) unless project.update_attributes(json_params)
        serialize(project)
    end

    delete '/projects/:id' do |id|
        project.destroy if project
        status 204
    end
end