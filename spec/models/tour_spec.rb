require 'spec_helper'

def requested_tour
  Tour.create(:email => "foo@foo.com")
end

def basic_info_tour
  tour = requested_tour
  tour.update_attributes(:first_name => "Joe", :last_name => "Dough", :phone => "234-556-7897")
  return tour
end

def extra_info_tour
  tour = basic_info_tour
  tour.update_attributes(:date => "2014-05-12", :location => "anywhere", :amenities => ["pool"])
  return tour
end

describe Tour do
  it { should be_invalid }
  it { should be_initial }
  it { should_not be_requested }
  it { should accept_values_for(:email, "foo@foo.com") }
  it { should_not accept_values_for(:email, "foo@junk") }

  context "that was requested" do
    subject { requested_tour }

    it { should be_invalid }
    it { should be_requested }
    it { should_not be_basic_info }
    its(:token) { should match(/[a-f0-9]{8}/) }

    context "with basic info input" do
      before(:each) do
        subject.attributes = {:first_name => "Joe", :last_name => "Dough", :phone => "234-556-7897"}
      end

      it { should be_valid }
      it { should_not accept_values_for(:first_name, "") }
      it { should_not accept_values_for(:last_name, "") }
      it { should_not accept_values_for(:phone, "") }
      it { should_not accept_values_for(:phone, "234-63-7897") }
      it { should_not accept_values_for(:phone, "234-6387-7897") }
      its(:save) { should be_true }
    end
  end

  context "with basic info saved" do
    subject { basic_info_tour }

    it { should be_invalid }
    it { should be_basic_info }
    it { should_not be_extra_info }

    context "and extra info input" do
      before(:each) do
        subject.attributes = {:date => "2014-05-12", :location => "anywhere", :amenities => ["pool"]}
      end

      it { should be_valid }
      it { should_not accept_values_for(:date, "") }
      it { should_not accept_values_for(:date, "2014") }
      it { should_not accept_values_for(:date, "not a date") }
      it { should_not accept_values_for(:location, "") }
      it { should_not accept_values_for(:amenities, ["anything else"]) }
      its(:save) { should be_true }

      it "needs amenities as an array" do
        subject.amenities = "pool"
        expect { subject.inspect }.to raise_error
      end
    end
  end

  context "with extra info saved" do
    subject { extra_info_tour }

    it { should be_invalid }
    it { should be_extra_info }
    it { should_not be_rated }
    it { should accept_values_for(:rating, 5) }
    it { should_not accept_values_for(:rating, -1) }
    it { should_not accept_values_for(:rating, 0) }
    it { should_not accept_values_for(:rating, 6) }
    it { should_not accept_values_for(:rating, "") }

    context "and rating input" do
      before(:each) { subject.rating = 5 }
      its(:save) { should be_true }
    end
  end

  context "with rating saved" do
    subject { extra_info_tour }

    before(:each) do
      subject.rating = 5
      subject.save
    end

    it { should be_valid }
    it { should be_rated }
    its(:save) { should be_true }
  end
end