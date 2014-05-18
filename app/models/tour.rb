class Tour < ActiveRecord::Base
  include TourStates
  after_initialize :initial!, :if => :new_record?
  before_save :update_state

  include IDTokenizer
  before_create :generate_token

  attr_accessible :email, :first_name, :last_name, :phone, :date, :location, :amenities, :rating

  validates :email, :presence => true, :format => /@.+[.].+/
  validates :first_name, :last_name, :phone, :presence => true, :if => :requested?
  validates :phone, :format => /^\D*(?:\d\D*){10}$/, :if => :requested?
  validates :date, :location, :presence => true, :if => :basic_info?
  validate :amenities_are_valid, :if => :basic_info?
  validates :rating, :presence => true, :inclusion => { :in => 1..5 }, :if => :extra_info?

  serialize :amenities, Array
  def self.valid_amenities
    ["pool", "rec room", "movie theater", "on site doctor", "time machine"]
  end

  protected
  def amenities_are_valid
    self.amenities.each do |a|
      errors.add(:amenities, "#{a} is not a valid amenity") unless Tour.valid_amenities.include?(a)
    end unless self.amenities.blank?
  end
end
