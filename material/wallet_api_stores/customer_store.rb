module Stores
  class CustomerStore < Store

    def stream_name
      '$ce-customer'
    end

    def accepted_params
      [:name,
        :maternalName,
        :paternalName,
        :phoneNumber,
        :email,
        :streetAddress,
        :city,
        :neighborhood,
        :state,
        :postalCode,
        :dateOfBirth,
        :gender,
        :currentEmploymentStartDate,
        :maritalStatus]
    end

    def self.configure(receiver)
      receiver.customer_store = instance
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "AssignFundsReceived"
          entity = calculate_rolling_deposits(entity, event)
        elsif event.type == "EnableCredit"
          entity[:creditEnabled] = true
        elsif event.type == "DisableCredit"
          entity[:creditEnabled] = false
        elsif event.type == "DesignateSweepAccount"
          entity[:sweepAccount] = {
            'type' => event.data['type'],
            'designation' => event.data['designation']
          }
        elsif event.type == "RemoveSweepAccount"
          entity[:sweepAccount] = nil
        end

      end

    end

    def calculate_rolling_deposits(entity, event)
      return entity unless event.data['time']
      original = (entity[:monthly_deposits] || []).dup
      entity[:monthly_deposits] = original.select{|e| Time.now - Time.parse(e.data['time']) < 30.days }.push(event)

      entity[:monthly_deposit_amount] = entity[:monthly_deposits].inject(0) { |mem, var| mem + var.data['amount'] }
      entity
    end
  end
end
