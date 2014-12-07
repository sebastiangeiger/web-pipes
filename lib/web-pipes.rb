require 'therubyracer'
require 'faraday'
require 'json'
require_relative 'web-pipes/javascript_executor'

raise "Please set your PIVOTAL_TOKEN" unless ENV["PIVOTAL_TOKEN"]
class PivotalTracker

  def projects
    response = connection.get "/services/v5/projects"
    raise unless response.success?
    JSON.parse(response.body)
  end

  def stories_for_project(project_id)
    response = connection.get "/services/v5/projects/#{project_id}/stories"
    raise unless response.success?
    JSON.parse(response.body)
  end

  def update_project_story(project_id, story_id, attributes = {})
    response = connection.put do |req|
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
    @connection ||= Faraday.new(:url => 'https://www.pivotaltracker.com') do |faraday|
      faraday.headers['X-TrackerToken'] = ENV["PIVOTAL_TOKEN"]
      faraday.adapter  Faraday.default_adapter
    end
  end
end

script = <<EOF
  var project = pivotal.projects.filter(function(project){
    return project.name === "ClariStream Management System";
  })[0];
  var stories = pivotal.stories_for_project(project.id);
  var offenders = stories.filter(function(story){
    var beginsWithId = new RegExp("^"+story.id+"\s+-");
    return (story.name.match(beginsWithId) === null);
  });
  offenders.forEach(function(offender){
    var newName = offender.id + " - " + offender.name;
    pivotal.update_project_story(project.id, offender.id, {name: newName});
  });
EOF

def STDOUT.log(*a)
  puts sprintf(*a.map(&:to_s))
end
