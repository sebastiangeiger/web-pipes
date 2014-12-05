require 'therubyracer'
require 'faraday'
require 'json'

raise "Please set your PIVOTAL_TOKEN" unless ENV["PIVOTAL_TOKEN"]
class PivotalTracker

  def connection
    @connection ||= Faraday.new(:url => 'https://www.pivotaltracker.com') do |faraday|
      faraday.headers['X-TrackerToken'] = ENV["PIVOTAL_TOKEN"]
      faraday.adapter  Faraday.default_adapter
    end
  end

  def projects
    response = connection.get "/services/v5/projects"
    raise unless response.success?
    JSON.parse(response.body)
  end

end

script = <<EOF
  var project = pivotal.projects.filter(function(project){
    return project.name === "ClariStream Management System";
  })[0];
  project.id;
EOF

cxt = V8::Context.new
cxt['pivotal'] = PivotalTracker.new
p cxt.eval(script)
