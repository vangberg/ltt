require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'

class User
  include DataMapper::Resource
  property :id,           Integer, :serial => true
  property :login,        String
  property :password,     String

  has n, :projects
  has 1, :tracking, :class_name => 'Entry'

  def track!(project)
    raise RuntimeError, 'Already tracking!' if tracking
    self.tracking = Entry.create(:project_id => project.id)
    save
  end

  def stop!
    raise "User is not tracking any project. Can't stop!" unless tracking
    tracking.duration = (Time.now - tracking.created_at).to_i
    self.tracking = nil
    save
  end
end

class Project
  include DataMapper::Resource
  property :id,         Integer, :serial => true
  property :name,       String
  property :short_url,  String
  property :user_id,    Integer

  belongs_to :user
  has n, :entries

  before :save, :make_short_url
  private
  def make_short_url
    self.short_url = name.gsub(/\W/, '-').downcase unless short_url
  end
end

class Entry
  include DataMapper::Resource
  property :id,         Integer, :serial => true
  property :duration,   Integer
  property :project_id, Integer
  property :user_id,    Integer
  property :created_at, Time

  belongs_to :project

  # Otherwise obj will not be dirty and created_at not set. sucks
  before(:create) { self.duration = 0 }
end

configure do
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
  User.create(:login => "harry", :password => "foob")
end

use Rack::Auth::Basic do |username, password|
  User.first(:login => username, :password => password)
end

helpers do
  def current_user
    @current_user ||= User.first(:login => request.env['REMOTE_USER'])
  end

  def post(path, &block)
    s = "<form action='#{path}' method='POST'>"
    s << Haml::Helpers.capture_haml(&block)
    s << "</form>"
  end

  def tracking?(project)
    current_user.tracking && current_user.tracking.project == project
  end
end

get '/' do
  redirect '/dashboard'
end

get '/dashboard' do
  haml :dashboard
end

post '/projects' do
  current_user.projects.build(params)
  redirect('/') if current_user.save
end

post '/track/:project' do
  begin
    project = current_user.projects.first(:short_url => params[:project])
    current_user.track!(project)
    redirect '/'
  rescue
    status 403
  end
end

post '/stop' do
  current_user.stop! if current_user.tracking
  redirect '/'
end

get('/timetracker.css') { sass :stylesheet }

use_in_file_templates!

__END__

@@ layout
!!!
%html
  %body
    = yield

@@ dashboard
%h1 Dashboard

#user=current_user.login
#projects
  - current_user.projects.each do |project|
    .project{:id => ('tracking' if tracking?(project))}
      %a{:href => "/#{project.short_url}"}=project.name
      - if tracking?(project)
        = post "/stop" do
          %input{:type => 'image', :alt => 'Stop'}
      - else
        = post "/track/#{project.short_url}" do
          %input{:type => 'image', :alt => 'Track'}

%form{:action => '/projects', :method => 'POST'}
  %label{:for => 'name'} Name
  %input{:type => 'text', :name => 'name', :id => 'name'}
  %input{:type => 'submit', :value => 'Create'}

@@ stylesheet
