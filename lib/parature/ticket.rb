
class Parature::Ticket
  include Parature::DefaultClient

  def initialize( parature_response )
    @response = parature_response
  end 
  def get(field)
    @response["@#{field}"]
  end
  def id
    get :id
  end
  def raw_detail!
    @raw_detail = client.make_api_request "Ticket", id
  end
  def raw_detail
    @raw_detail || raw_detail!
  end
  def raw_ticket
    raw_detail["Ticket"]
  end
  def raw_custom_fields
    raw_ticket["Custom_Field"]
  end
  def status
    raw_ticket["Ticket_Status"]["Status"]["Name"]["#text"]
  end
end

