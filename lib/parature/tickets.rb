
class Parature::Tickets
  attr_reader :raw_response

  def initialize( parature_response )
    @raw_response = parature_response 
  end
  def entities
    @raw_response["Entities"]
  end
  def entity(name)
    entities["@#{name}"]
  end

  %w{total results page page-size}.each do |field|
    define_method(field.gsub('-', '_')) do
      entity field
    end
  end

  def href
    entity :href
  end

  def self.all(client = Parature.default_client)
    Parature::Tickets.new client.make_api_request "Ticket"
  end

  def raw_tickets
    entities["Ticket"]
  end

  def first
    Ticket.new raw_tickets.first
  end

  include Enumerable
  def each(&block)
    if @tickets.nil? 
      @tickets = raw_tickets.map {|t| Ticket.new t}
    end

    @tickets.each(&block)
  end
end

