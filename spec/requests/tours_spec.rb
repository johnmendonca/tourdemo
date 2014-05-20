require 'spec_helper'
require 'capybara/rspec'
require 'capybara/email/rspec'

describe "Tours" do
  describe "new tour form" do
    it("redirects from root") { visit "/" }
    it("redirects from index") { visit "/tours" }
    it("is accessed by the new action") { visit "/tours/new" }
    after(:each) { should_be_on_page(:request_form) }
  end

  describe "requesting a tour" do
    before(:each) { visit "/tours/new" }

    it "returns to form with invalid input" do
      # Leave fields blank
      click_button("Sign Me Up")
      page.should have_content("Email is invalid")
      should_be_on_page(:request_form)
    end

    context "with valid input" do
      before(:each) { request_tour }

      it("goes to thanks page") { should_be_on_page(:thanks) }
      it("sends an email with a link") { should_have_email(:activation) }
    end    
  end

  describe "basic info form" do
    let(:id) { create_tour_for_id }

    it("is accessed by the edit action") { visit "/tours/#{id}/edit" }
    it("redirects from show action") { visit("/tours/#{id}") }
    after(:each) { should_be_on_page(:basic_info) }
  end

  describe "submitting basic info" do
    let(:id) { create_tour_for_id }
    before(:each) { visit "/tours/#{id}/edit" }

    it "returns to form with invalid input" do
      # Leave fields blank
      click_button "Update Tour"
      page.should have_content("First name can't be blank")
      should_be_on_page(:basic_info)
    end

    it "goes to extra info form with valid input" do
      input_valid_basic_info
      click_button("Update Tour")
      should_be_on_page(:extra_info)
    end 
  end

  describe "extra info form" do
    let(:id) { create_tour_for_id }
    before(:each) { submit_basic_info(id) }

    it("is accessed by the edit action") { visit "/tours/#{id}/edit" }
    it("redirects from show action") { visit("/tours/#{id}") }
    after(:each) { should_be_on_page(:extra_info) }
  end

  describe "submitting extra info" do
    let(:id) { create_tour_for_id }
    before(:each) do
      submit_basic_info(id)
      visit "/tours/#{id}/edit"
    end

    it "returns to form with invalid input" do
      # Leave fields blank
      click_button "Update Tour"
      page.should have_content("Date can't be blank")
      should_be_on_page(:extra_info)
    end

    context "with valid input" do
      before(:each) do
        input_valid_extra_info
        click_button("Update Tour")
      end

      it("goes to confirm page") { should_be_on_page(:confirm) }
      it("sends an email with a link") { should_have_email(:confirmation) }
    end 
  end

  describe "tour info page" do
    let(:id) { create_tour_for_id }
    before(:each) do
      submit_basic_info(id)
      submit_extra_info(id)
    end

    it("is accessed from the show action") { visit "/tours/#{id}" }
    it("redirects from edit action") { visit "/tours/#{id}/edit" }

    after(:each) { all_attributes_should_be_on_page }

    it "can submit a rating" do
      visit "/tours/#{id}"
      page.should have_content("How was it?")
      click_button "Update Tour"
      page.should_not have_content("How was it?")      
    end
  end
end
