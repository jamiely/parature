require 'rest_client'
require 'mechanize'
require 'json'

module Parature
  class Client
    attr_accessor :output_format
    attr_reader :host

    def initialize(options)
      @host = options[:host]
      @token = options[:token]
      @username = options[:username]
      @password = options[:password]
      @account_id = options[:account_id]
      @department_id = options[:department_id]
      @output_format = :json
    end

    def mechanize
      @mech = Mechanize.new if @mech.nil?
      @mech
    end

    # Logs into the actual Parature website to perform functions not
    # available via the API
    def login
      return if @logged_in

      mechanize.get("https://#{@host}/ics/service/login.asp") do |page|
        page.form_with(:action => 'loginSQL.asp') do |form|
          user_field = form.field_with(:name => "email")
          user_field.value = @username
          pass_field = form.field_with(:name => "password")
          pass_field.value = @password
        end.click_button
      end

      @logged_in = true
    end

    def make_api_request_with_params(*what, options)
      data = what.join("/")
      url = "https://#{@host}/api/v1/#{@account_id}/#{@department_id}/#{data}"
      params = {
        _output_: @output_format,
        _token_: @token
      }.merge(options)

      response = RestClient.get url, {params: params}

      # remove some garbage characters at the beginning
      normalized_response = response[3..-1]
      JSON.parse normalized_response
    end
    def make_api_request(*what)
      make_api_request_with_params *what, {}
    end

    def get_ticket(id)
      Ticket.find id
    end
  end
end

