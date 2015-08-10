module Stores
  class IssuePhoneStore < Store

    def stream_name
      '$ce-issuePhone'
    end

    def accepted_params
      [
        :id,
        :customerId,
        :model,
        :imei
      ]
    end

    def for_customer_id(id)
      all.select{|l| l[:customerId] == id}
    end


    def self.configure(receiver)
      receiver.issue_phone_store = instance
    end
  end
end
