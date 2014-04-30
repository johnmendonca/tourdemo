require 'spec_helper'

describe Tour do
  before(:each) do
    @tour = Tour.create
  end

  it "is not valid" do
    expect(@tour).to be_invalid
  end

  it "does not accept bad emails" do
    @tour.email = "Some@junk"
    expect(@tour).to be_invalid
  end

  it "needs a good email" do
    @tour.email = "foo@foo.foo"
    expect(@tour).to be_valid
  end

  it "has initial state only" do
    expect(@tour.initial?).to be_true
    expect(@tour.requested?).to be_false
  end

  context "that was requested" do
    before(:each) do
      @tour.email = "some@good.site"
      expect(@tour.save).to be_true
    end

    it "is no longer valid" do
      expect(@tour).to be_invalid
    end

    it "has requested state only" do
      expect(@tour.requested?).to be_true
      expect(@tour.basic_info?).to be_false
    end

    it "needs all basic info fields" do
      @tour.first_name = "Joe"
      expect(@tour).to be_invalid
      @tour.last_name = "Dough"
      expect(@tour).to be_invalid
      @tour.first_name = nil
      @tour.phone = "234-556-7897"
      expect(@tour).to be_invalid
      @tour.first_name = "Joe" #all 3
      expect(@tour).to be_valid
    end

    it "needs phone to contain 10 digits" do
      @tour.first_name = "Joe"
      @tour.last_name = "Dough"
      @tour.phone = "234-63-7897"      
      expect(@tour).to be_invalid
      @tour.phone = "234-6387-7897"      
      expect(@tour).to be_invalid
      @tour.phone = "234.556-7897"
      expect(@tour).to be_valid
    end

    context "and basic info collected" do
      before(:each) do
        @tour.first_name = "Joe"
        @tour.last_name = "Dough"
        @tour.phone = "234-556-7897"
        expect(@tour.save).to be_true
      end

      it "is no longer valid" do
        expect(@tour).to be_invalid
      end

      it "has basic info state only" do
        expect(@tour.basic_info?).to be_true
        expect(@tour.extra_info?).to be_false
      end

      it "needs date and location fields" do
        @tour.amenities = nil
        @tour.date = "2014-04-25"
        expect(@tour).to be_invalid
        @tour.location = "Dough Factory"
        expect(@tour).to be_valid
      end

      it "needs a valid date format" do
        @tour.location = "Dough Factory"
        @tour.amenities = ["pool"]
        @tour.date = "junk"
        expect(@tour).to be_invalid        
      end

      it "needs amenities as an array" do
        @tour.amenities = "pool"        
        expect { @tour.inspect }.to raise_error        
      end

      it "needs certain values for amenities" do
        @tour.date = "2014-04-25"
        @tour.location = "Dough Factory"
        @tour.amenities = ["fast cars"]
        expect(@tour).to be_invalid
        @tour.amenities = ["pool", "rec room", "movie theater", "on site doctor", "time machine"]
        expect(@tour).to be_valid
      end

      context "and extra info collected" do
        before(:each) do
          @tour.date = "2014-04-25"
          @tour.location = "Dough Factory"
          @tour.amenities = ["pool"]
          expect(@tour.save).to be_true
        end

        it "is no longer valid" do
          expect(@tour).to be_invalid
        end

        it "has extra info state only" do
          expect(@tour.extra_info?).to be_true
          expect(@tour.rated?).to be_false
        end

        it "needs certain values for rating" do
          @tour.rating = 11
          expect(@tour).to be_invalid
          @tour.rating = 6
          expect(@tour).to be_invalid
          @tour.rating = 5
          expect(@tour).to be_valid
        end

        context "and rating submitted" do
          before(:each) do
            @tour.rating = 5
            expect(@tour.save).to be_true
          end

          it "is still valid" do
            expect(@tour).to be_valid
          end

          it "has rated state" do
            expect(@tour.rated?).to be_true
          end
        end
      end
    end
  end
end
