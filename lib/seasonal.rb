require 'rubygems'

require 'time'
require 'tzinfo'

module Seasonal

  class Event
    attr_accessor :payload
    attr_accessor :zone
    attr_accessor :start_date
    attr_accessor :start_time
    attr_accessor :end_date
    attr_accessor :end_time

    def initialize(payload, zone, start_date, start_time=nil, end_date=nil,
      end_time=nil)
      if end_time.nil?
        if start_time.nil?
          end_time = '23:59:59'
        else
          if end_date.nil?
            end_time = start_time
          else
            end_time = '23:59:59'
          end
        end
      end

      start_time = '00:00:00' if start_time.nil?

      end_date = start_date if end_date.nil?

      @payload = payload
      @zone = zone
      @start_date = start_date
      @end_date = end_date
      @start_time = start_time
      @end_time = end_time
    end

    def start
      tz = TZInfo::Timezone.get(zone)
      tz.local_to_utc(Time.parse("#{start_date} #{start_time}"))
    end

    def ennd
      tz = TZInfo::Timezone.get(zone)
      tz.local_to_utc(Time.parse("#{end_date} #{end_time}"))
    end

    def going_on?(test_time=Time.now)
      # puts "#{start} - #{ennd}"
      test_time >= start and test_time <= ennd
    end

  end

  class Calendar < Array

    def going_on(test_time=Time.now)
      each { |event| yield event if event.going_on?(test_time) }
    end

  end

end
