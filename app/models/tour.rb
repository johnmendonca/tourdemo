class Tour < ActiveRecord::Base
  STATES = { :nothing => 0, :requested => 1, :basic_info => 2, :extra_info => 3, :rating => 4 }

  validates :email, :presence => true
  
end
