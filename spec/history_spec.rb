require 'vcr'
require 'parature'

describe "ticket history" do
  before :each do
    VCR.use_cassette 'specific ticket' do
      @ticket = Parature.client.get_ticket "8521421"
      @history_entries = @ticket.history
    end
  end

  it "has a parent ticket" do
    @history_entries.first.ticket.should_not be nil
    @history_entries.first.ticket.id.should be @ticket.id
  end
end

