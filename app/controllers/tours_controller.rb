class ToursController < ApplicationController
  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new(params[:tour].slice(:email))
    if @tour.save
      TourMailer.activation_email(@tour).deliver
      #flash[:notice] = "Shortcut: <a href=\"#{tour_url(@tour)}\">#{tour_url(@tour)}</a>".html_safe
      redirect_to '/thanks'
    else
      flash[:error] = view_context.errors_display(@tour)
      redirect_to new_tour_path
    end
  end

  def show
    @tour = Tour.find_by_token(params[:id])
    redirect_to edit_tour_path(params[:id]) unless @tour.extra_info?
  end

  def edit
    @tour = Tour.find_by_token(params[:id])
    redirect_to tour_path(@tour) if @tour.extra_info?
  end

  def update
    @tour = Tour.find_by_token(params[:id])
    final_form = @tour.basic_info? && !@tour.extra_info?

    unless @tour.update_attributes params[:tour].slice(*@tour.fields_to_update)
      flash[:error] = view_context.errors_display(@tour)
      return redirect_to edit_tour_path(@tour)
    end
    
    if final_form && @tour.extra_info?
      TourMailer.confirmation_email(@tour).deliver
      TourMailer.scheduling_email(@tour, request.remote_ip).deliver
      #flash[:notice] = "Shortcut: <a href=\"#{tour_url(@tour)}\">#{tour_url(@tour)}</a>".html_safe
      return redirect_to '/success'
    end
    redirect_to tour_path(@tour)
  end
end
