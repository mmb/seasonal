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

    def initialize(payload, zone, options={})
      @payload = payload
      @zone = zone
      @start_date = options[:start_date]
      @start_time = options[:start_time] || '00:00:00'
      @end_date = options[:end_date] || options[:start_date]

      if options[:end_time].nil?
        if options[:start_time].nil?
          @end_time = '23:59:59'
        else
          if options[:end_date].nil?
            @end_time = options[:start_time]
          else
            @end_time = '23:59:59'
          end
        end
      else
        @end_time = options[:end_time]
      end
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
