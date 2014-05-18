module TourStates
  STATES = { :initial => 0, :requested => 1, :basic_info => 2, :extra_info => 3, :rated => 4 }
  
  STATES.keys.each do |key|
    define_method("#{key}?") do
      self.state >= STATES[key]
    end
    define_method("#{key}!") do
      self.state = STATES[key]
    end
    protected "#{key}!".to_sym
  end

  FIELD_GROUPS = [ [:email], [:first_name, :last_name, :phone], [:date, :location, :amenities], [:rating] ]
  
  def fields_to_update
    FIELD_GROUPS[self.state]
  end

  protected
  def update_state
    self.state += 1 if valid? && !rated?
  end
end