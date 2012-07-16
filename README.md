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
    include Parature

    # We need the API token when we retrieve data via the API
    Parature.config host: "www.supportcenteronline.com", account_id: 100, department_id: 4000, token: "apitoken"
    tickets = Tickets.all
    
    # Get the next page of tickets
    tickets.next_page

    # Get the first page of tickets from last week
    Tickets.last_week

    # Get the first page of tickets from last month
    Tickets.last_month

    # Get the second page of tickets from this week
    Tickets.this_week.next_page 

    # Get all the statuses
    puts tickets.collect &:status

    # Get a single ticket
    ticket = Ticket.find '99999'

    # Get history information
    ticket.history

    # Get only history with time spent
    ticket.history_with_time

    # Get only history with csrs associated
    ticket.history_with_csr

    # Do the same for all tickets
    tickets.history
    tickets.history_with_time
    tickets.history_with_csr
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

