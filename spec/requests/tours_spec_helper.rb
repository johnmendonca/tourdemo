module ToursSpecHelper
  PAGE_COPY = {
    :request_form => "Sign Up For A Tour",
    :thanks => "Thanks for signing up",
    :basic_info => "Tell Us About Yourself",
    :extra_info => "What You Want To Do?",
    :confirm => "Get ready!",
    :activation => "Thanks for your interest",
    :confirmation => "This Tour is good to go!"
  }

  def should_be_on_page(page_id)
    page.should have_content(PAGE_COPY[page_id])
  end

  def should_have_email(email_id)
    open_email("foo@foo.com")
    current_email.should have_content(PAGE_COPY[email_id])
    current_email.body.should match(/\/tours\/[0-9a-f]{8}/)
  end

  def request_tour
    fill_in("Email", :with => "foo@foo.com")
    click_button("Sign Me Up")
  end

  def input_valid_basic_info
    fill_in("First name", :with => "joe")
    fill_in("Last name", :with => "dough")
    fill_in("Phone", :with => "234-456-3434")
  end

  def input_valid_extra_info
    fill_in("Date", :with => "2014-05-13")
    fill_in("Location", :with => "Anywhere")
  end

  def create_tour_for_id
    visit "/tours/new"
    request_tour
    open_email("foo@foo.com")
    current_email.body =~ /\/tours\/([0-9a-f]{8})/
    return $1
  end

  def submit_basic_info(id)
    visit "/tours/#{id}/edit"
    input_valid_basic_info
    click_button("Update Tour")
  end

  def submit_extra_info(id)
    visit "/tours/#{id}/edit"
    input_valid_extra_info
    click_button("Update Tour")
  end

  def all_attributes_should_be_on_page
    page.should have_content("Email")
    page.should have_content("First name")
    page.should have_content("Last name")
    page.should have_content("Phone")
    page.should have_content("Date")
    page.should have_content("Location")
  end
end