module Stores
  class DisburseFundsStore < Store

    def stream_name
      '$ce-disburseFunds'
    end

    def accepted_params
      [
        :id,
        :transfers,
        :date,
        :sequenceNumber,
        :confirmationCode,

        :initiatedTime,
        :completedTime,
        :failedTime
      ]
    end

    def self.configure(receiver)
      receiver.disburse_funds_store = instance
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "Initiate"
          entity[:state] = "Initiated"
        elsif event.type == "Success"
          entity[:state] = "Succeeded"
        elsif event.type == "Failure"
          entity[:state] = "Failed"
        end
      end

    end


  end
end
