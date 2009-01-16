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

    def has_year(s)
      p = Time.parse(s)
      p.eql?(Time.parse(s + ' ' + (p.year + 1).to_s))
    end

    def is_yearly_range
      !start.nil? and !has_year(start) and !ennd.nil? and !has_year(ennd)
    end

    def change_year(time, new_year)
      Time.utc(new_year, time.utc.month, time.utc.day, time.utc.hour,
        time.utc.min, time.utc.sec, time.utc.usec)
    end

    def going_on_yearly_range(test_time)
      if is_yearly_range
        start_shifted = change_year(start_utc, test_time.utc.year)
        end_shifted = change_year(end_utc, test_time.utc.year)
        if (end_utc < start_utc)
          start_shifted_prev = change_year(start_shifted,
            start_shifted.year - 1)
          end_shifted_next = change_year(end_shifted, end_shifted.year + 1)
          ((start_shifted_prev <= test_time and test_time <= end_shifted) or
            (start_shifted <= test_time and test_time <= end_shifted_next))
        else
          (start_shifted <= test_time and test_time <= end_shifted)
        end
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
          result = going_on_yearly_range(test_time)
          if result.nil?
            result = (start_utc <= test_time and test_time <= end_utc)
          end
        end
      end
      result
    end

  end

  class Calendar < Array

    def going_on(options={})
      options = { :at => Time.now, :payloads => true }.merge(options)
      if block_given?
        if options[:payloads]
          each { |event| yield event.payload if event.going_on?(options[:at]) }
        else
          each { |event| yield event if event.going_on?(options[:at]) }
        end
      else
        result = reject { |event| !event.going_on?(options[:at]) }
        if options[:payloads]
          if result.empty? and !options[:or_if_none].nil?
            result.push(options[:or_if_none])
          else
            result.collect { |e| e.payload }
          end
        else
          result
        end
      end
    end

  end

end
