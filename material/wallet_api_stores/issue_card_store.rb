module Stores
  class IssueCardStore < Store

    def stream_name
      '$ce-issueCard'
    end

    def accepted_params
      [
        :id,
        :customerId,
        :cardId,
        :pan,
        :name,
        :paternalName,
        :maternalName,
        :dateOfBirth,
        :streetAddress,
        :neighborhood,
        :postalCode,
        :city,
        :maritalStatus,
        :gender,
        :issuedTime,
        :activationTime,
        :activationConfirmationNumber,
        :activationFailureTime,
        :activationFailureReason
      ]
    end

    def issued
      all.select{|l|
        l[:issuedTime] && !l[:activationTime] && !l[:activationFailureTime]
      }
    end

    def find_by_pan(pan)
      cards = all.select{|l|
        l[:pan] == pan
      }

      if active(cards).count > 0
        return active(cards).first
      else
        return cards.last
      end
    end

    def active(list)
      list.select{|l| l[:state] == 'Activated'}
    end

    def active_for_customer_id(id)
      all.select{|l| l[:customerId] == id}.select{|l| l[:state] == "Activated"}
    end


    def for_customer_id(id)
      all.select{|l| l[:customerId] == id}
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "Initiate"
          entity[:state] = "Issued"
        elsif event.type == "Activated"
          entity[:state] = "Activated"
        elsif event.type == "ActivationFailed"
          entity[:state] = "Activation Failed"
        elsif event.type == "Cancel"
          entity[:state] = "Cancelled"
        end
      end

    end

    def self.configure(receiver)
      receiver.issue_card_store = instance
    end
  end
end
