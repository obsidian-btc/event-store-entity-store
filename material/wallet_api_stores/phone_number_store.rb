module Stores
  class PhoneNumberStore < Store

    def stream_name
      '$ce-phoneNumber'
    end

    def accepted_params
      [
        :phoneNumber,
        :carrier,
      ]
    end

    def self.configure(receiver)
      receiver.phone_number_store = instance
    end
  end
end
