module Stores
  class AccountStore < Store

    def stream_name
      '$ce-account'
    end

    def accepted_params
      [:owner]
    end

    # We are assuming that Deposit and Withdrawal events reflect state correctly.
    #
    # This is a limiting constraint.

    def transactions(account_id)
      es_client.read_all_events_forward("account-#{account_id}").select{|e| e.type == "Deposit" || e.type == "Withdrawal"}
    rescue HttpEventstore::StreamNotFound
      []
    end

    def update_store_from_event(event)

      super(event) do |entity|
        entity[:balance] ||= 0

        if event.type == "Deposit"
          entity[:balance] += event.data["amount"].to_i
          entity[:last_activity_time] = event.data["time"]
        elsif event.type == "Withdrawal"
          entity[:balance] -= event.data["amount"].to_i
          entity[:last_activity_time] = event.data["time"]
        elsif event.type == "Adjustment"
          entity[:balance] = event.data["balance"].to_i
          entity[:last_activity_time] = event.data["time"]
        end
      end
    end

    def self.configure(receiver)
      receiver.account_store = instance
    end
  end
end


