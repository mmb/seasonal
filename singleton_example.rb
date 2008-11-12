require 'seasonal'
require 'singleton'

module Calendars

  class HeaderCalendar < Seasonal::Calendar
    include Singleton

    def initialize
      push(Seasonal::Event.new('#d00d1e', 'America/New_York',
        :start => 'nov 10', :end => 'dec 20 23:59:59'))
      push(Seasonal::Event.new('#bedded', 'America/New_York',
        :start => 'dec 21', :end => 'mar 20 23:59:59'))
    end

  end

end

Calendars::HeaderCalendar.instance.going_on { |e| puts e }
