class Tour < ActiveRecord::Base
  STATES = { :initial => 0, :requested => 1, :basic_info => 2, :extra_info => 3, :rated => 4 }
  FIELDS = [ [:email], [:first_name, :last_name, :phone], [:date, :location, :amenities], [:rating] ]
  STATES.keys.each do |key|
    define_method("#{key}?") do
      self.state >= STATES[key]
    end
    define_method("#{key}!") do
      self.state = STATES[key]
    end
    protected "#{key}!".to_sym
  end

  def self.valid_amenities
    ["pool", "rec room", "movie theater", "on site doctor", "time machine"]
  end
  serialize :amenities, Array

  attr_accessible :email, :first_name, :last_name, :phone, :date, :location, :amenities, :rating

  validates :email, :presence => true, :format => /@.+[.].+/
  validates :first_name, :last_name, :phone, :presence => true, :if => :requested?
  validates :phone, :format => /^\D*(?:\d\D*){10}$/, :if => :requested?
  validates :date, :location, :presence => true, :if => :basic_info?
  validate :amenities_are_valid, :if => :basic_info?
  validates :rating, :presence => true, :inclusion => { :in => 1..5 }, :if => :extra_info?

  after_initialize :initial!, :if => :new_record?
  before_save :update_state
  before_create :generate_token

  def to_param
    self.token
  end

  def fields_to_update
    FIELDS[self.state]
  end

  protected
  def update_state
    self.state += 1 if valid? && !rated?
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.hex(4)
      break random_token unless Tour.exists?(:token => random_token)
    end
  end

  def amenities_are_valid
    self.amenities.each do |a|
      errors.add(:amenities, "#{a} is not a valid amenity") unless Tour.valid_amenities.include?(a)
    end unless self.amenities.blank?
  end
end
