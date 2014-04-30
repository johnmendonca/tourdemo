module ToursHelper
  def clean_array_str(str)
    str.sub('["','').sub('"]','').gsub('", "',', ')
  end
end
