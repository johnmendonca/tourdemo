module ToursHelper
  def errors_display(model)
    all_errors = "Please correct the following:<br><ul>"
    model.errors.full_messages.each do |e|
      all_errors << "<li>#{e}</li>" 
    end
    all_errors << "</ul>"
    return all_errors.html_safe
  end
  
  def clean_array_str(str)
    str.sub('["','').sub('"]','').gsub('", "',', ')
  end
end
