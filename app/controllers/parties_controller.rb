class PartiesController < ApplicationController
  def new
    if !current_user
      flash[:alert] = "You must be logged in to access your dashboard"
      redirect_to user_movie_path(params[:user_id], params[:movie_id])
    else
      @user = User.find(params[:user_id])
      @movie = MovieFacade.new.find_movie(params[:movie_id])
      @users = User.all
    end
  end

  def create
    party = PartyFacade.create_party(params)
    if party.save
      redirect_to controller: 'user_parties',
                  action: 'create',
                  participants: params[:participants],
                  party_host: params[:user_id],
                  movie: params[:movie_id],
                  party: party.id
    else
      redirect_to new_user_movie_party_path(params[:user_id], params[:movie_id])
      flash[:alert] = "All fields must be filled out and party length must be greater than movie length"
    end
  end
end
