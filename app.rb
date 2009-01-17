require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-aggregates'
require 'dm-timestamps'
require 'dm-validations'

class User
  include DataMapper::Resource
  property :id,           Integer, :serial => true
  property :login,        String
  property :password,     String

  has n, :projects
  has n, :entries, :through => :projects
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

  validates_present :name

  before :save, :make_short_url
  private
  def make_short_url
    self.short_url = name.gsub(/\W/, '-').downcase unless short_url
  end
end

class Integer
  def to_human
    h, m = *divmod(3600)
    hour_string   = h > 0 ? "#{h}h" : ""
    minute_string = "#{m/60}m"
    hour_string + minute_string
  end
end

class Entry
  include DataMapper::Resource
  property :id,           Integer, :serial => true
  property :duration,     Integer
  property :description,  String
  property :project_id,   Integer
  property :user_id,      Integer
  property :created_at,   Time

  belongs_to :project

  # Otherwise obj will not be dirty and created_at not set. sucks
  before(:create) { self.duration = 0 unless duration }

  def duration_as_string=(string)
    match = string.delete(' ').match(/((\d+)h)?((\d+)m)?/)
    h, m = match[2], match[4]
    self.duration = h.to_i * 3600 + m.to_i * 60
  end
end

configure :test do
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
end

configure :development do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/development.db")
  DataMapper.auto_upgrade!
end

configure :production do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/production.db")
  DataMapper.auto_upgrade!
end

use Rack::Auth::Basic do |username, password|
  User.first(:login => username, :password => password)
end

helpers do
  def current_user
    @current_user ||= User.first(:login => request.env['REMOTE_USER'])
  end

  def post(path, &block) rest_link(path, :post, &block) end
  def put(path, &block) rest_link(path, :put, &block) end
  def delete(path, &block) rest_link(path, :delete, &block) end

  def rest_link(path, method, &block)
    f = "<form action='#{path}' method='post'>"
    f << "<input type='hidden' name='_method' value='#{method.to_s}' />"
    f << Haml::Helpers.capture_haml(&block)
    f << "</form>"
  end

  def tracking?(project)
    current_user.tracking && current_user.tracking.project == project
  end

  def find_project(short_url)
    current_user.projects.first(:short_url => short_url)
  end
end

get '/' do
  redirect '/dashboard'
end

get '/dashboard' do
  haml :dashboard
end

post '/projects' do
  current_user.projects.create(params)
  redirect('/')
end

put '/projects/:short_url' do
  project = find_project(params[:short_url])
  project.update_attributes(params['project'])
  redirect '/'
end

delete '/projects/:project' do
  project = find_project(params[:project])
  project.destroy
  redirect '/'
end

post '/projects/:project/entries' do
  project = find_project(params[:project])
  project.entries.create(:duration_as_string => params[:duration])
  redirect '/'
end

post '/track/:project' do
  project = find_project(params[:project])
  current_user.track!(project)
  redirect '/'
end

post '/stop' do
  current_user.stop! if current_user.tracking
  redirect '/'
end

delete '/entries/:id' do
  entry = current_user.entries.get(params[:id])
  entry.destroy
  redirect '/'
end

get '/timetracker.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

use_in_file_templates!

__END__

@@ layout
!!!
%html
  %head
    %title
      the lil' time tracker
    %link{:rel => 'stylesheet', :type => 'text/css', :href => '/timetracker.css'}
    %script{:type => 'text/javascript', :src => '/jquery-1.3.min.js'}
    %script{:type => 'text/javascript', :src => '/timetracker.js'}
  %body
    #content
      = yield
    #footer
      icons from <a href='http://www.famfamfam.com/lab/icons/silk/'>famfamfam</a>

@@ dashboard
%h1 the lil' time tracker

#user==Hello #{current_user.login}, are you ready to track?

#projects
  - current_user.projects.each do |project|
    .project{:id => ('tracking' if tracking?(project))}
      .bar
        %a.name=project.name
        %span.total=(project.entries.sum(:duration) || 0).to_human
      - if !current_user.tracking || tracking?(project)
        - if tracking?(project)
          = post "/stop" do
            %input{:type => 'image', :src => '/images/clock_stop.png', :alt => 'Stop'}
        - else
          = post "/track/#{project.short_url}" do
            %input{:type => 'image', :src => '/images/clock.png', :alt => 'Track'}
      .project-body
        .controls
          = put "/projects/#{project.short_url}" do
            %input{:type => 'text', :value => project.short_url, :name => 'project[short_url]'}
            %button Change alias!
          = post "/projects/#{project.short_url}/entries" do
            %input{:type => 'text', :name => 'duration'}
            %button Add time!
        %span.delete
          = delete "/projects/#{project.short_url}" do
            %input{:type => 'image', :src => '/images/delete.png', :alt => 'Delete'}
        .entries
          - project.entries.all(:order => [:id.desc]).each do |entry|
            - unless entry == current_user.tracking
              .entry
                = delete "/entries/#{entry.id}" do
                  %button
                    =entry.created_at.strftime("%d/%m:")
                    =entry.duration.to_human

#new_project
  %form{:action => '/projects', :method => 'post'}
    %input{:type => 'text', :name => 'name', :id => 'name'}
    %button{:value => 'Create'}
      +
