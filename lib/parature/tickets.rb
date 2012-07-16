module Parature
class Tickets
  attr_reader :raw_response

  PAGE_SIZE = 100

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

  def self.all
    Tickets.new Parature.client.make_api_request_with_params "Ticket", :_pageSize_ => PAGE_SIZE
  end

  def self.by_date_created(date_created)
    response = Parature.client.make_api_request_with_params "Ticket", :_pageSize_ => PAGE_SIZE,
      'Date_Created' => date_created
    Tickets.new response
  end

  # The metaclass allows us to dynamically add class methods
  metaclass = class << self
    self
  end
  %w{last_month this_week last_week today yesterday this_month}.each do |keyword|
    metaclass.instance_eval do
      define_method keyword do
        Tickets.by_date_created "_#{keyword}_"
      end
    end
  end

  def raw_tickets
    entities["Ticket"]
  end

  def first
    Ticket.new raw_tickets.first
  end

  def result_count
    entities["@results"].to_i
  end

  def page_number
    entities["@page"].to_i
  end

  def next_page
    Tickets.new Parature.client.make_api_request_with_params "Ticket", 
      :_startPage_ => page_number + 1,
      :_pageSize_ => PAGE_SIZE
  end

  def history
    @history = collect(&:history).flatten if @history.nil?
    @history
  end

  def history_with_csrs
    history.select(&:csr_entry?)
  end

  def history_with_time
    history.select(&:has_time?)
  end

  def total_time_spent
    @total_time = collect(&:total_time_spent).inject(0) { |sum, t| sum + t } if @total_time.nil?
    @total_time
  end

  include Enumerable
  def each(&block)
    if @tickets.nil? 
      @tickets = raw_tickets.map {|t| Ticket.new t}
    end

    @tickets.each(&block)
  end
end
end

