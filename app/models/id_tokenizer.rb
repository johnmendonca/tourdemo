module IDTokenizer
  def to_param
    self.token
  end

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.hex(4)
      break random_token unless self.class.exists?(:token => random_token)
    end
  end
end