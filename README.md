# Parature

Use this gem to interact with Parature.

## Installation

Add this line to your application's Gemfile:

    gem 'parature'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parature

## Usage

### Setup

If you want to use the API functionality, you must provide a Parature
API token.

If you want to use the automated functionality through the site, you
should create a service account with appropriate access.

Where data is available through the API, that is the preferred source.

### Examples

Here's an example of API interaction

    % pry
    require 'parature'

    # We need the API token when we retrieve data via the API
    Parature.config host: "www.supportcenteronline.com", account_id: 100, department_id: 4000, token: "apitoken"
    tickets = Parature::Tickets.all

    # Get all the statuses
    puts tickets.collect &:status

An example of downloading a ticket report from Parature.

    > pry
    require 'parature'
    # Here, user name and password are required inputs because time is not available via the API
    Parature.config host: "www.supportcenteronline.com", account_id: 100, department_id: 4000, username: "test@example.com", password: "blah"
    metrics = Parature::TicketMetricsByCSR.new
    puts metrics.records
    # Sample output
    # {:csr=>"Clark Kent", :date_range=>"6/10 - 6/16", :total_time=>"0"}
    # {:csr=>"Clark Kent", :date_range=>"6/17 - 6/23", :total_time=>"0"}
    # {:csr=>"Clark Kent", :date_range=>"6/24 - 6/30", :total_time=>"12 day 14 hr"}
    # {:csr=>"Clark Kent", :date_range=>"7/1 - 7/7", :total_time=>"0"}
    # {:csr=>"Clark Kent", :date_range=>"7/8 - 7/10", :total_time=>"0"}
    # {:csr=>"Jamie Ly", :date_range=>"6/10 - 6/16", :total_time=>"0"}
    # {:csr=>"Jamie Ly", :date_range=>"6/17 - 6/23", :total_time=>"0"}
    # {:csr=>"Jamie Ly", :date_range=>"6/24 - 6/30", :total_time=>"0"}
    # {:csr=>"Jamie Ly", :date_range=>"7/1 - 7/7", :total_time=>"30 day 20 hr "}
    # {:csr=>"Jamie Ly", :date_range=>"7/8 - 7/10", :total_time=>"0"}
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

