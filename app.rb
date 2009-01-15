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
  before(:create) { self.duration = 0 unless duration }

  def to_human
    h, m = *duration.divmod(3600)
    hour_string   = h > 0 ? "#{h}h" : ""
    minute_string = "#{m/60}m"
    hour_string + minute_string
  end
end

configure :test do
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
end

configure :development do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/development.db")
  DataMapper.auto_migrate!
end

configure :production do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/production.db")
  DataMapper.auto_upgrade!
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

#user==Welcome #{current_user.login}, are you ready to track?

#projects
  - current_user.projects.each do |project|
    .project{:id => ('tracking' if tracking?(project))}
      %a.name=project.name
      - if !current_user.tracking || tracking?(project)
        - if tracking?(project)
          = post "/stop" do
            %input{:type => 'image', :src => '/images/clock_stop.png', :alt => 'Stop'}
        - else
          = post "/track/#{project.short_url}" do
            %input{:type => 'image', :src => '/images/clock.png', :alt => 'Track'}
      .entries
        - project.entries.all(:order => [:id.desc]).each do |entry|
          - unless entry == current_user.tracking
            .entry
              =entry.to_human

%h2 New project
%form{:action => '/projects', :method => 'POST'}
  %label{:for => 'name'} Name
  %input{:type => 'text', :name => 'name', :id => 'name'}
  %input{:type => 'submit', :value => 'Create'}

@@ stylesheet
body
  :font-family Helvetica, sans-serif
#content
  :width 600px
  :margin auto
h1
  :font-style italic
  :color #FF205F
  :border-bottom 5px solid #FF205F
#projects
  form
    :display inline
  .project
    a.name
      :display inline-block
      :position relative
      :width 520px
      :margin 7px 10px 7px 0
      :padding 5px 10px
      :font-size 1.7em
      :background-color #ff205f
      :color white
      :text-decoration none
    a.name:hover
      :color #ff205f
      :background-color white
    .entries
      :display none
#footer
  :display none
  :text-align center
  :color #666
  :font-size 0.6em
