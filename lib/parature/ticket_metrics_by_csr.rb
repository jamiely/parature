require 'parature/util'

class Parature::TicketMetricsByCSR
  def self.to_stat_str(sym)
    case sym
    when :total_time
      "sumBillingDuration|Total Time Spent (hr)"
    end
  end

  def initialize()
    @statistic = :total_time
  end

  def records
    tbl = load
    # throw away the first cell
    dates = tbl.search('tr:first-child > td').collect(&:content)[1..-1]
    content = tbl.search('tr')
    # skip the first row cuz its just headers
    content[1..-1].collect do |row|
      cells = row.search('td')
      name = cells[0].content
      rest = cells[1..-1]
      entries = dates.zip rest.collect &:content
      entries.collect do |entry|
        { csr: name, date_range: entry.first, total_time: entry[1] }
      end
    end.flatten
  end

  def records_by_csr
    records.group_by {|r| r[:csr]}
  end
  def records_by_date_range
    records.group_by {|r| r[:date_range]}
  end
  
  # Retrieves the html corresponding to the report
  def load
    return @html_table unless @html_table.nil?

    Parature.client.login
    report_page = Parature.client.mechanize.post "https://#{Parature.client.host}/ics/metrics/metricsTicketCSR.asp",
      'statShort' => self.class.to_stat_str(@statShort)
    dom_heading = report_page.search '#excelReportType'
    dom_table = report_page.search '#excelContent'
    @html_table = dom_table
    #@html_table = Parature::Util.force_ascii dom_table
  end
end

