module Stores
  class Store
    @@instance_lock = Mutex.new

    def es_client
      @es_client ||= HttpEventstore::Connection.new do |config|
        config.endpoint = $event_store_client_settings.host
        config.port = $event_store_client_settings.port
        config.page_size = 1000
      end
    end

    def ids
      @entities.keys
    end

    def save(entity)
      @entities ||= {}

      @entities[entity[:id]] = entity

      entity[:id]
    end

    def get(id, refresh_before_fetch=true)
      refresh if refresh_before_fetch
      string_id = id.to_s
      @entities ||= {}
      @entities.fetch(string_id) { {id: string_id} }
    end

    def all
      refresh
      entities = []
      @entities ||= {}
      @entities.each do |key, value|
        entities.push(value)
      end
      entities
    end

    def stream_name
      raise NotImplementedError
    end

    def events(stream_name)
      if !@stream_position
        logger.info "No current state, trying to restore from snapshots"
        category = stream_name.gsub('$ce-','')
        snapshots = Snapshot.where(category: category)
        logger.debug "Querying for snaphots"
        if snapshots.count > 0
          events_after_snapshot_restoration = restore_from_snapshots(snapshots)
          return events_after_snapshot_restoration
        end
        logger.info "Reading stream from the beginning..."
        return es_client.read_all_events_forward(stream_name)
      else
        logger.info "Getting events for stream, starting from: #{@stream_position+1}"
        return es_client.read_events_forward(stream_name, @stream_position+1, 100).reverse
      end
    end

    def restore_from_snapshots(snapshots)
      logger.debug "Snapshots found, restoring from them"
      if snapshots.select(:read_stream_position).uniq(:read_stream_position).count == 1
        snapshots.all.each do |snapshot|
          save(snapshot.data.symbolize_keys)
        end

        @stream_position = snapshots.first.read_stream_position
        logger.info "State reconstructed, now returning just new events"
        return es_client.read_events_forward(stream_name, @stream_position+1, 1000).reverse
      else
        logger.info "Snapshots were in an inconsistent state, returning all events"
        return es_client.read_all_events_forward(stream_name)
      end
    end

    def snapshot
      category = stream_name.gsub('$ce-','')
      all.dup.each do |entity|
        snapshot = Snapshot.find_or_create_by(stream_name: "#{category}-#{entity[:id]}")
        snapshot.category = category
        snapshot.read_stream_position = @stream_position
        snapshot.data = entity
        snapshot.save
      end
    end

    def refresh
      @last_fetch_time ||= Time.at(0)

      return unless Time.now - @last_fetch_time > 0.25

      @@instance_lock.synchronize do
        events = events(stream_name)
        return unless events

        events.each do |event|
          update_store_from_event(event)
        end
        @last_fetch_time = Time.now
      end
    end

    def logger
      Telemetry::Logger.get(self)
    end

    def update_store_from_event(event)

      entity_id = event.stream_name.split('-')[1..-1].join('-')

      entity = get(entity_id, false)

      event.data.each do |key, value|
        next unless accepted_params.include?(key.to_sym)
        entity[key.to_sym] = value
      end
      yield entity if block_given?

      @stream_position = event.position
      logger.trace "New last event position is #{@stream_position}"
      save(entity)
    end

    def accepted_params
      raise NotImplementedError
    end

    def self.instance
      @instance ||= new
    end

    def self.reset
      @instance = nil
    end

  end
end
