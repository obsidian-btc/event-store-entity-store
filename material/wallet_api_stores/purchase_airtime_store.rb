module Stores
  class PurchaseAirtimeStore < Store

    def stream_name
      '$ce-purchaseAirtime'
    end

    def accepted_params
      [
        :id,
        :phoneNumber,
        :name,
        :amount,
        :carrier,
        :initiatedTime,
        :confirmationCode,
        :completedTime,
        :message,
        :failureTime,
      ]
    end

    def self.configure(receiver)
      receiver.phone_number_store = instance
    end
  end
end
