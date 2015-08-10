module Stores
  class LoanStore < Store

    def stream_name
      '$ce-loan'
    end

    def accepted_params
      [
        :customerId,
        :amount,
        :debitId,
        :creditId,
        :fee,
        :balance,
        :term,
        :requestedTime,
        :approvedTime,
        :rejectedTime,
        :fundedTime,
        :withdrawalCap,
        :reference
      ]
    end

    def for_customer(customer)
      all.select{|l| l[:customerId] == customer.id.to_s}
    end

    def for_reference(reference)
      all.select{|l| l[:reference] == reference}
    end

    def active_for_customer_id(customer_id)
      all
        .select{|l| l[:customerId] == customer_id}
        .select{|l| l[:state] == "Funded" }
    end

    def self.configure(receiver)
      receiver.loan_store = instance
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "Requested"
          entity[:state] = "Requested"
        elsif event.type == "Approved"
          entity[:state] = "Approved"
        elsif event.type == "Funded"
          entity[:balance] = entity[:amount].to_i + entity[:fee].to_i
          entity[:totalRepaymentAmount] = entity[:balance]
          entity[:state] = "Funded"
        elsif event.type == "Rejected"
          entity[:state] = "Rejected"
        elsif event.type == "Closed"
          entity[:state] = "Closed"
        elsif event.type == "Defunded"
          entity[:balance] = 0
          entity[:state] = "Defunded"
        elsif event.type == "PaymentApplied"
          entity[:balance] = entity[:balance].to_i - event.data['paymentAmount'].to_i
          if entity[:balance] == 0
            entity[:state] = "Closed"
            entity[:closedDate] = Time.parse(event.data['paymentAppliedTime']).to_date.to_s
          else
            entity[:state] = "Funded"
          end
        end
      end
    end
  end
end
