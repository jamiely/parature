module Parature
  class TicketAttachment
    attr_accessor :href, :guid, :name

    def self.load_from_parature_hash(hash)
      t = TicketAttachment.new
      %w{@href Guid Name}.each do |key|
        method = key.downcase.gsub('@', '').to_sym
        t.send(method, hash[key])
      end
    end
  end
end

