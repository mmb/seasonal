$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'time'
require 'seasonal'
require 'test/unit'

class SeasonalTest < Test::Unit::TestCase

  def test_start_date
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'jan 1')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year - 1, 12, 30, 23, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 1, 1, 17, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 1, 2, 5, 0, 0)))
  end

  def test_start_date_end_time
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'feb 22',
      :end_time => '5:00pm')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 4, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 13, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 22, 0, 1)))
  end

  def test_start_date_end_date
    e = Seasonal::Event.new(nil, 'America/New_York',
      :start_date => 'mar 3 2003', :end_date => 'mar 5 2003')

    assert_equal(false, e.going_on?(Time.utc(2003, 3, 3, 4, 59, 59)))

    assert(e.going_on?(Time.utc(2003, 3, 4, 0, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(2003, 3, 6, 5, 0, 0)))
  end

  def test_start_date_end_date_end_time
    e = Seasonal::Event.new(nil, 'America/New_York',
      :start_date => 'apr 20', :end_date => 'may 1', :end_time => '00:00')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 4, 20, 3, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 5, 1, 0, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(Time.now.utc.year, 5, 2, 0, 0, 0)))
  end

  def test_start_date_start_time
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'may 10',
      :start_time => '10:00am')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 13, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 14, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 14, 0, 1)))
  end

  def test_start_date_start_time_end_time
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'june 22',
      :start_time => '10:00am', :end_time => '10:30am')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 13, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 14, 15, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 14, 30, 1)))
  end

  def test_start_date_start_time_end_date
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'july 4',
      :start_time => '11:00pm', :end_date => 'jul 5')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 7, 5, 2, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 7, 5, 15, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(Time.now.utc.year, 7, 6, 4, 0, 0)))
  end

  def test_start_date_start_time_end_date_end_time
    e = Seasonal::Event.new(nil, 'America/New_York', :start_date => 'aug 19',
      :start_time => '1:00pm', :end_date => 'aug 21', :end_time => '2:00pm')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 8, 19, 16, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 8, 20, 15, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 8, 21, 18, 0, 1)))
  end

end
