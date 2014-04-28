class Tour < ActiveRecord::Base
  STATES = { :initial => 0, :requested => 1, :basic_info => 2, :extra_info => 3, :rated => 4 }
  FIELDS = [ [:email], [:first_name, :last_name, :phone], [:date, :location, :amenities], [:rating], nil ]
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

  validates :email, :presence => true, :format => /@/
  validates :first_name, :last_name, :phone, :presence => true, :if => :requested?
  validates :date, :location, :amenities, :presence => true, :if => :basic_info?
  # validates :amenities, :inclusion => { :in => valid_amenities }, :if => :basic_info?
  validates :rating, :presence => true, :if => :extra_info?

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
end
