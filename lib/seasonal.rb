require 'rubygems'

require 'time'
require 'tzinfo'

module Seasonal

  class Event
    attr_accessor :payload
    attr_accessor :zone
    attr_accessor :start
    attr_accessor :ennd

    def initialize(payload, zone, options={})
      @payload = payload
      @zone = zone
      if options[:on]
        @start = "#{options[:on]} 00:00:00"
        @ennd = "#{options[:on]} 23:59:59"
      else
        @start = options[:start]
        @ennd = options[:end]
      end
    end

    def start_utc
      unless start.nil?
        tz = TZInfo::Timezone.get(zone)
        tz.local_to_utc(Time.parse(start))
      end
    end

    def end_utc
      unless ennd.nil?
        tz = TZInfo::Timezone.get(zone)
        tz.local_to_utc(Time.parse(ennd))
      end
    end

    def going_on?(test_time=Time.now)
      # puts "#{start_utc} - #{end_utc}"
      if start_utc.nil?
        if end_utc.nil?
          result = false
        else
          result = test_time <= end_utc
        end
      else
        if end_utc.nil?
          result = test_time >= start_utc
        else
          result = (test_time >= start_utc and test_time <= end_utc)
        end
      end
      result
    end

  end

  class Calendar < Array

    def going_on(test_time=Time.now)
      if block_given?
        each { |event| yield event if event.going_on?(test_time) }
      else
        reject { |event| !event.going_on?(test_time) }
      end
    end

  end

end
