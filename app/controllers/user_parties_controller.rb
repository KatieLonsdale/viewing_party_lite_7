class UserPartiesController < ApplicationController
  def create
    @party = Party.find(params[:party])
    @party.user_parties.create(user_id: params[:party_host], is_host: true)
    if params[:participants]
      params[:participants].each do |participant|
      @party.user_parties.create(user_id: participant)
      end
    end

    redirect_to "/dashboard"
  end
end
