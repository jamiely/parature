require 'spec_helper'
require 'parature'

describe "the parature client" do
  before :all do
    require './spec/vcr_setup.rb'
  end
  it "can load config" do
    Parature.client.should_not be nil
  end

  describe "ticket api" do
    include Parature

    it "can get tickets" do
      VCR.use_cassette('all tickets') do
        Tickets.all.result_count.should be > 0 
      end
    end

    it "can get the next page of tickets" do
      VCR.use_cassette('all tickets') do
        @first = Tickets.all
      end
      VCR.use_cassette('all tickets - next page') do 
        @next = @first.next_page
      end
      @next.should_not be nil
      next_ids = @next.collect(&:id)
      first_ids = @first.collect(&:id)

      first_ids.each do |id|
        next_ids.member?(id).should_not be true
      end
    end

    it "can enumerate tickets" do
      VCR.use_cassette('all tickets') do
        @tickets = Tickets.all
      end
      statuses = @tickets.collect(&:id)
      statuses.should have_exactly(@tickets.result_count).item
    end

    it "can get tickets from this week" do
      VCR.use_cassette "this week's tickets" do
        @tickets = Tickets.this_week
      end
      @tickets.should_not be nil
      VCR.use_cassette "this week's ticket detail" do
        @tickets.total_time_spent.should be > 0
      end
    end

    it "can get the tickets from last week" do
      VCR.use_cassette "last week's tickets" do
        @tickets = Tickets.last_week
      end
      @tickets.should_not be nil
      VCR.use_cassette "last week's ticket detail" do
        @tickets.total_time_spent.should be > 0
      end
    end

    it "can get a single ticket" do
      VCR.use_cassette 'all tickets' do
        @tickets = Tickets.all
      end

      target = @tickets.first
      VCR.use_cassette 'single ticket' do
        @ticket = Parature.client.get_ticket target.id
      end

      @ticket.department.should_not be_empty
      @ticket.total_time_spent.should eq 0
    end
  end
end

