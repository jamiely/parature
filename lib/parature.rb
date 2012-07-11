require "parature/version"

module Parature::DefaultClient
  def client
    @client || Parature.default_client 
  end
end

require "parature/client"
require "parature/ticket"
require "parature/tickets"
require "parature/util"
require "parature/ticket_metrics_by_csr"

module Parature
  @default_client = nil
  def self.config(options)
    @default_client = Parature::Client.new options
  end

  def self.default_client
    @default_client 
  end
end


