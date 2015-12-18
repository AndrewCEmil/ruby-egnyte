module Egnyte

  class Client

    def latest_event_id
      Event::latest(@session)
    end

    def oldest_event_id
      Event::oldest(@session)
    end

    def latest_and_oldest_event_ids
      Event::latest_and_oldest(@session)
    end

    def each_event_since(base_event_id, &block)
      Event::each_event_since(@session, base_event_id, block)
    end

  end

  class Event

    def self.latest(session)
      res = session.get("https://#{session.domain}.#{EGNYTE_DOMAIN}/#{session.api}/v1/events/cursor")
      res["latest_event_id"]
    end

    def self.oldest(session)
      res = session.get("https://#{session.domain}.#{EGNYTE_DOMAIN}/#{session.api}/v1/events/cursor")
      res["oldest_event_id"]
    end

    def self.latest_and_oldest(session)
      res = session.get("https://#{session.domain}.#{EGNYTE_DOMAIN}/#{session.api}/v1/events/cursor")
      {latest: res["latest_event_id"], oldest: res["oldest_event_id"]}
    end

    def self.since_event(session, event_id, params)
      url = "https://#{session.domain}.#{EGNYTE_DOMAIN}/#{session.api}/v1/events?id=#{event_id}"
      params.each do |k,v|
        url = "#{url}&#{k}=#{v}"
      end
      session.get(url)
    end

    def self.each_event_since(session, event_id, block)
      base_event_id = event_id
      loop do
        res = Event::since_event(session, base_event_id, {count: 100})
        break if res["events"].nil?
        res["events"].each { |e| block.call(e) }
        base_event_id = res["events"].last["id"]
        break if res["count"] < 100
      end

    end

  end

end
