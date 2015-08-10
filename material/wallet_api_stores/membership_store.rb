module Stores
  class MembershipStore < Store

    def stream_name
      '$ce-membership'
    end

    def accepted_params
      [:customerId, :branchId, :branchInternalId]
    end

    def self.configure(receiver)
      receiver.membership_store = instance
    end

    def initialize
      @customers = {}
      @branches = {}
    end

    def customers_for_branch(branch_id)
      refresh
      @branches[branch_id] || []
    end

    def find(customer_id, branch_id)
      refresh
      all.each do |membership|
        return membership[:id] if membership[:branchId] == branch_id.to_s && membership[:customerId] == customer_id.to_s
      end
      nil
    end

    def branches_for_customer(customer_id)
      refresh
      @customers[customer_id] || []
    end

    def enroll(customer_id, branch_id)
      logger.info "Enrolling customer into branch (Customer ID: #{customer_id}, Branch ID: #{branch_id})"

      customer_branches = @customers[customer_id] || []
      customer_branches.push(branch_id)
      @customers[customer_id] = customer_branches

      branch_customers = @branches[branch_id] || []
      branch_customers.push(customer_id)
      @branches[branch_id] = branch_customers

    end

    def disenroll(customer_id, branch_id)

      customer_branches = @customers[customer_id] || []
      customer_branches.delete(branch_id)
      @customers[customer_id] = customer_branches

      branch_customers = @branches[branch_id] || []
      branch_customers.delete(customer_id)
      @branches[branch_id] = branch_customers
    end

    def update_store_from_event(event)

      super(event) do |entity|
        logger.info "Processing event: #{event}"
        if event.type == "Enroll"
          enroll(event.data['customerId'], event.data['branchId'])
        elsif event.type == "Disenroll"
          disenroll(event.data['customerId'], event.data['branchId'])
        end
      end

    end
  end
end
