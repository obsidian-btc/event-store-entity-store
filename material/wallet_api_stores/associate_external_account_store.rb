module Stores
  class AssociateExternalAccountStore < Store

    def stream_name
      '$ce-associateExternalAccount'
    end

    def accepted_params
      [
        :id,
        :customerId,
        :number,
        :type
      ]
    end

    def for_customer_id(id)
      all.select{|l| l[:customerId] == id}
    end


    def self.configure(receiver)
      receiver.associate_external_account_store = instance
    end
  end
end
