require 'sinatra'
require "data_mapper"

set :views, Proc.new {File.join(root, '..', "views") }
set :public_folder, Proc.new { File.join(root, '..', "public") }

env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a prostgres dataase on Localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require_relative './link' # this needs to be done after datamapper is initialised
require_relative './tag'
require_relative './user'

# After declaring your models, you should finalise them
DataMapper.finalize

# However, the database tables don't excist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade! 


get '/' do
	@links = Link.all
	erb :index
end


post '/links' do
	url = params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map{|tag| Tag.first_or_create(:text => tag)}
	Link.create(:url => url.gsub("http://", ""), :title => title, :tags => tags)
	redirect to('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
	# note the view is in views/users/new.erb
	# we need the quotes because otherwise ruby would divide the symbol :users by the variable new (which makers no sense)
	erb :"users/new"
end

enable :sessions
set :session_secret, 'super secret'

post '/users' do
	user = User.create(:email => params[:email],
				:password => params[:password])
	session[:user_id] = user.id
	redirect to('/')
end

post '/users' do
  User.create(:email => params[:email], 
              :password => params[:password])
  redirect to('/')
end

helpers do

	def current_user
		@current_user ||=User.get(session[:user_id]) if session[:user_id]
	end

end











