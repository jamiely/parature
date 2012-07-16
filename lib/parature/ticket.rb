module Parature
class Ticket
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
    @raw_detail = self.class.get_detail id
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

  def assigned_to
    assigned = @response["Assigned_To"]
    text get_path assigned, 'Csr.Full_Name'
  end
  def href
    get :href
  end

  def status
    text get_path raw_ticket, 'Ticket_Status.Status.Name'
  end
  def history
    @history = raw_ticket["ActionHistory"]["History"].collect {|h| HistoryEntry.load_from_parature_hash h} if @history.nil?
    @history 
  end
  def history_having_time
    history.select(&:has_time?)
  end
  def history_with_csrs
    history.select(&:csr_entry?)
  end
  def time_spent
    history.collect(&:time_spent)
  end
  # Returns the time spent in s
  def total_time_spent
    @seconds_spent = history.collect(&:seconds_spent).inject(0) {|sum, t| sum + t } if @seconds_spent.nil?
    @seconds_spent
  end
  def total_time_spent_minutes
    @seconds_spent / 60
  end

  def date_created
    text @response['Date_Created']
  end

  def date_updated
    text @response['Date_Updated']
  end

  def department
    text get_path @response, 'Department.Department.Name' rescue 'None'
  end

  def attachments
    return @attachments unless @attachments.nil?

    attachments = get_path @response, 'Ticket_Attachments.Attachment'
    @attachments = attachments.collect do |attachment_hash|
      TicketAttachment.load_from_parature_hash attachment_hash
    end
  end

  def self.get_detail(id)
    Parature.client.make_api_request_with_params "Ticket", id, :_history_ => true
  end
  def self.find(id)
    data = get_detail id
    t  = Ticket.new data
    t.instance_variable_set('@raw_detail', data)
    t
  end 

  private
  def text(node)
    node["#text"]
  end
  def get_path(hash, dotted_path)
    dotted_path.split('.').inject(hash) { |h, k| h[k] }
  end
end
end 
