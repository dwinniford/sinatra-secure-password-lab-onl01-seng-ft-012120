require "./config/environment"
require "./app/models/user"
require "pry"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params['username'].length > 0 && params['password'].length > 0 
      user = User.new(username: params['username'], password: params['password'])
      user.save
      redirect '/login'
    else 
      redirect '/failure'
    end 
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end
  
  patch '/account/deposit' do 
    deposit(params[:deposit].to_i) 
    redirect '/account'
  end 
  
  patch '/account/withdraw' do 
    if params[:withdraw].to_i <= User.find(session[:user_id]).balance
      withdraw(params[:withdraw].to_i) 
      redirect '/account'
    else 
      
  end 


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params['username'])
    if user && user.authenticate(params['password'])
      session[:user_id] = user.id
      redirect "/account"
    else 
      redirect "/failure"
    end 
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
    
    def deposit(amount)
      user = User.find(session[:user_id])
      user.balance += amount 
      user.save
    end 
      
  end

end
