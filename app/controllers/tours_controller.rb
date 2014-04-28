class ToursController < ApplicationController
  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new(params[:tour].slice(:email))
    if @tour.save
      #send email
      flash[:notice] = "<a href=\"#{tour_url(@tour)}\">#{tour_url(@tour)}</a>".html_safe
      redirect_to '/thanks'
    else
      flash[:error] = "Put a better email address please"
      redirect_to new_tour_path
    end
  end

  def show
    @tour = Tour.find_by_token(params[:id])
    unless @tour.extra_info?
      redirect_to edit_tour_path(params[:id])
    end
  end

  def edit
    @tour = Tour.find_by_token(params[:id])
  end

  def update
    @tour = Tour.find_by_token(params[:id])
    unless @tour.update_attributes params[:tour].slice(*@tour.fields_to_update)
      flash[:error] = "Please enter valid info for each field"
    end
    redirect_to tour_path(@tour)
  end

  def thanks
    @info = "Thanks for signing up"
    render :info
  end
end
