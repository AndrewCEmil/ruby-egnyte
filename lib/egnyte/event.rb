module Egnyte
  class Event
    def self.latest(session)
      session.get("https://#{domain}.#{EGNYTE_DOMAIN}/#{@api}/v1/events/cursor"
      x["latest_event_id"]
    end

    def self.oldest(session)
      session.get("https://#{domain}.#{EGNYTE_DOMAIN}/#{@api}/v1/events/cursor"
      x["oldest_event_id"]
    end

    def self.latest_and_oldest(session)
      session.get("https://#{domain}.#{EGNYTE_DOMAIN}/#{@api}/v1/events/cursor"
      {latest: x["latest_event_id"], oldest: x["oldest_event_id"]}
    end

    def self.since_event(session, event_id, params)
      url = "https://#{domain}.#{EGNYTE_DOMAIN}/#{@api}/v1/events/cursor?id=#{event_id}"
      params.each do |k,v|
        url = "#{url}&#{k}=#{v}"
      end
    end
  end
end
