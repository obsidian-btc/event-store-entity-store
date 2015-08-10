module Stores
  class CardStore < Store

    def stream_name
      '$ce-card'
    end

    def accepted_params
      [
        :id,
        :pan
      ]
    end

    def self.configure(receiver)
      receiver.card_store = instance
    end

    def find_by_pan(pan)
      all.select{|l|
        l[:pan] == pan
      }.first
    end
  end
end
