require('sinatra')
require('sinatra/reloader')


require_relative('./models/film')

also_reload('./models/*')

get '/films' do
  @films = Film.all
  erb(:films)
end

get '/films/:id' do
 @films = Film.find(params[:id])
 erb(:film_detail)
end
