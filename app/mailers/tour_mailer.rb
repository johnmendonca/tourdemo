class TourMailer < ActionMailer::Base
  default :from => "tours@example.com"

  def activation_email(tour)
    @tour = tour
    mail(:to => @tour.email, :subject => "Are You Ready To Tour?")
  end

  def confirmation_email(tour)
    @tour = tour
    mail(:to => @tour.email, :subject => "The Tour Is On!")
  end

  def scheduling_email(tour, ip)
    @tour = tour
    @ip = ip
    mail(:to => "tours@example.com", :subject => "New Tour Scheduled")
  end
end
