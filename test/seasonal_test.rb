$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'time'
require 'seasonal'
require 'test/unit'

class SeasonalTest < Test::Unit::TestCase

  def test_event_none
    e = Seasonal::Event.new(nil, 'America/New_York')

    assert_equal(false, e.going_on?)
  end

  def test_event_start
    ss = 'jan 2'
    start = Time.parse(ss).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :start => ss)

    assert_equal(false, e.going_on?(start - 1))
    assert(e.going_on?(start))
    assert(e.going_on?(start + 1))
  end

  def test_event_end
    es = 'mar 17'
    ennd = Time.parse(es).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :end => es)

    assert(e.going_on?(ennd - 1))
    assert(e.going_on?(ennd))
    assert_equal(false, e.going_on?(ennd + 1))
  end

  def test_event_start_end
    ss = 'aug 29'
    es = 'sep 1'
    start = Time.parse(ss).utc
    ennd = Time.parse(es).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :start => ss, :end => es)

    assert_equal(false, e.going_on?(start - 1))
    assert(e.going_on?(start))
    assert(e.going_on?(ennd))
    assert_equal(false, e.going_on?(ennd + 1))
  end

  def test_calendar_going_on
    calendar = Seasonal::Calendar.new
    calendar.push(Seasonal::Event.new(nil, 'America/New_York',
      :start => 'June 22, 1978 10:00pm', :end => 'June 28, 1978 10:00am'))
    assert_equal(1, calendar.going_on(Time.utc(1978, 6, 23, 2, 0, 0)).size)
  end

  def test_calendar_going_on_or_if_none_some
    calendar = Seasonal::Calendar.new
    calendar.push(Seasonal::Event.new(nil, 'America/New_York',
      :start => 'Sep 14, 1999 1:10pm', :end => 'Sep 15, 1999 12:00am'))
    assert_equal(1, calendar.going_on(Time.utc(1999, 9, 14, 18, 11, 1)).size)
  end

  def test_calendar_going_on_or_if_none_none
    calendar = Seasonal::Calendar.new
    calendar.push(Seasonal::Event.new(nil, 'America/New_York',
      :start => '05/01/2007', :end => '05/03/2007'))
    or_if_none = 'default'
    assert_equal(1, calendar.going_on(Time.utc(2007, 5, 5, 0, 0, 0),
      :or_if_none => or_if_none).size)
    assert_equal(or_if_none, calendar.going_on(Time.utc(2007, 5, 5, 0, 0, 0),
      :or_if_none => or_if_none).first)
  end

  def test_calendar_going_on_block
    calendar = Seasonal::Calendar.new
    payload = 'test'
    calendar.push(Seasonal::Event.new(payload, 'America/New_York',
      :start => 'apr 11', :end => 'may 5'))
    result = false
    calendar.going_on(Time.utc(Time.now.utc.year, 4, 16, 1, 2, 3)) do |e|
      assert(payload, e.payload)
      result = true
    end
    assert(result)
  end

  def test_calendar_on
    calendar = Seasonal::Calendar.new
    calendar.push(Seasonal::Event.new(nil, 'America/New_York',
      :on => Time.now.strftime('%b %d')))
    assert_equal(1, calendar.going_on(Time.now).size)
  end

  def test_calendar_payload
    calendar = Seasonal::Calendar.new
    payload = 'test'
    calendar.push(Seasonal::Event.new(payload, 'America/New_York',
      :on => Time.now.strftime('%b %d')))
    assert_equal(1, calendar.going_on(Time.now).size)
    assert_equal(payload, calendar.going_on.first.payload)
  end

end
