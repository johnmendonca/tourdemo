class ToursController < ApplicationController
  def create
    @tour = Tour.new(params[:tour])
    @tour.save!
    #send email
    redirect_to('/thanks')
  end

  def show
    @tour = Tour.find(params[:id])
  end

  def edit
    @tour = Tour.find(params[:id])
  end

  def update
    @tour = Tour.find(params[:id])
  end

  def thanks
    @info = "Thanks for signing up"
    render :info
  end
end
