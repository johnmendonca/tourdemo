class InfoController < ApplicationController
  def thanks
    @info = "Thanks for signing up"
    render :info
  end

  def success
    @info = "You've successfully signed up for a tour.  Get ready!"
    render :info
  end
end
