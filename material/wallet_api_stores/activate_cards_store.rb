module Stores
  class ActivateCardsStore < Store

    def stream_name
      '$ce-activateCards'
    end

    def accepted_params
      [
        :id,
        :cards,
        :date,
        :sequenceNumber,
        :confirmationCode,

        :initiatedTime,
        :sentTime,
        :sendFailureTime,
        :errors
      ]
    end

    def initiated
      all.select{|l|
        l[:initiatedTime] && !l[:sentTime] && !l[:sendFailureTime]
      }
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "Initiate"
          entity[:state] = "Initiated"
        elsif event.type == "SendSuccessful"
          entity[:state] = "Successful"
        elsif event.type == "SendFailure"
          entity[:state] = "Failed"
        end
      end

    end

    def self.configure(receiver)
      receiver.ac_store = instance
    end
  end
end
