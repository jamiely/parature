require 'spec_helper'
require 'parature'
require 'vcr'

describe "a ticket" do
  include Parature

  before :each do
    VCR.use_cassette 'all tickets' do
      @tickets = Tickets.all
    end

    VCR.use_cassette 'specific ticket' do
      @ticket = Parature.client.get_ticket "8521421"
    end
  end

  it "has time spent records" do
    entry = @ticket.history.first
    entry.id.should_not be nil
    entry.action_name.should_not be nil
    entry.old_status.should_not be_empty
    entry.new_status.should_not be_empty
    entry.time_spent.should_not be nil
    entry.minutes_spent.is_a?(Numeric).should be true
  end

  it "has history" do
    history = @ticket.history
    history.should_not be_empty
    history.each do |entry|
      entry.csr_entry?.should be(!entry.csr.nil?)
      entry.system_entry?.should be(entry.csr.nil?)
    end
  end
end

