class TrackEvent
  class << self
    def formatter
      @formatter ||= proc { |severity, datetime, _progname, msg| "#{severity},#{datetime},#{msg}\n" }
    end

    def tracker
      @tracker ||= Logger.new(Rails.root.join('log', 'track_events.log'), formatter: formatter)
    end

    def track(user, event)
      user_id = user.is_a?(User) ? user.id : user
      tracker.info("#{user_id},#{event}")
    end
  end
end
