require "parature/version"
require "parature/client"
require "parature/ticket"
require "parature/tickets"
require "parature/ticket_attachment"
require "parature/history_entry"
require "parature/util"
require "parature/ticket_metrics_by_csr"

module Parature
  @default_client = nil
  def self.config(options)
    @default_client = Parature::Client.new options
  end

  def self.client
    @default_client 
  end
end


