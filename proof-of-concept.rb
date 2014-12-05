require 'therubyracer'
require 'faraday'
require 'json'

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

  private

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
  stories.filter(function(story){
    var beginsWithId = new RegExp("^"+story.id+"\s+-");
    return (story.name.match(beginsWithId) === null);
  }).map(function(story) { return story.name });
EOF

cxt = V8::Context.new
cxt['pivotal'] = PivotalTracker.new
cxt['console'] = STDOUT
def STDOUT.log(*a)
  puts sprintf(*a.map(&:to_s))
end
p cxt.eval(script).to_a
