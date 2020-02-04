require("sinatra")
require("sinatra/contrib/all") if development?
require("pry-byebug")

require_relative("./models/film")
also_reload("./models/*")

get "/films" do
  @films = Film.all()
  erb(:index)
end

get "/films/:id" do
  @film = Film.find(params[:id])
  erb(:film)
end
