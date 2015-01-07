require 'therubyracer'
require 'faraday'
require 'json'
require_relative 'web-pipes/javascript_executor'
require_relative 'web-pipes/simple_api'

fail 'Please set your PIVOTAL_TOKEN' unless ENV['PIVOTAL_TOKEN']
class PivotalTracker
  def projects
    response = connection.get '/services/v5/projects'
    fail unless response.success?
    JSON.parse(response.body)
  end

  def stories_for_project(project_id)
    response = connection.get "/services/v5/projects/#{project_id}/stories"
    fail unless response.success?
    JSON.parse(response.body)
  end

  def update_project_story(project_id, story_id, attributes = {})
    connection.put do |req|
      req.url "/services/v5/projects/#{project_id}/stories/#{story_id}"
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.dump(to_hash(attributes))
    end
  end

  private

  def to_hash(object)
    if object.is_a? Hash
      object
    else
      object.reduce({}) do |hash, attribute|
        key, value = attribute
        hash.merge(key => value)
      end
    end
  end

  def connection
    base_url = 'https://www.pivotaltracker.com'
    @connection ||= Faraday.new(url: base_url) do |faraday|
      faraday.headers['X-TrackerToken'] = ENV['PIVOTAL_TOKEN']
      faraday.adapter Faraday.default_adapter
    end
  end
end
