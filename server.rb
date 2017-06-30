require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'
require './models/project'

Mongoid.load! "mongoid.config"

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