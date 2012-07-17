module Parature
  class HistoryEntry
    attr_accessor :id, :action_id, :action_name, :action_target, :old_status, 
      :new_status, :time_spent, :ticket
    def initialize
      time_spent = 0
    end
    def has_time?
      milliseconds_spent > 0
    end
    def milliseconds_spent
      time_spent['#text'].to_i
    end
    def seconds_spent
      milliseconds_spent / 1000.0
    end
    def minutes_spent
      seconds_spent / 60.0
    end
    def action_target_type
      action_target['@target-type']
    end
    def action_target_name
      csr = action_target['Csr']
      csr.nil? ? action_target_type : csr['Full_Name']['#text']
    end
    def system_entry?
      action_target_type == "System"
    end
    def csr_entry?
      action_target_type == "Csr"
    end
    def csr
      csr = action_target['Csr']
      csr.nil? ? nil : csr['Full_Name']['#text']
    end
    def ticket_id
      ticket.id
    end
    def self.load_from_parature_hash(parent_ticket, h)
      entry = HistoryEntry.new
      entry.id = h['@id']
      entry.action_id = h['Action']['@id']
      entry.action_name = h['Action']['@name']
      entry.old_status = h['Old_Status']['Status']['Name']['#text']
      entry.new_status = h['New_Status']['Status']['Name']['#text']
      entry.time_spent = h['Time_Spent']
      entry.action_target = h['Action_Target']
      entry.ticket = parent_ticket
      entry
    end
  end
end

