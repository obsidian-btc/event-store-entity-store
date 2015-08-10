module Stores
  class AssignFundsStore < Store

    def stream_name
      '$ce-assignFunds'
    end

    def accepted_params
      [
        :assigner,
        :paylines,
        :fileId,
        :initiatedTime
      ]
    end

    def self.configure(receiver)
      receiver.assign_funds_store = instance
    end

  end
end
