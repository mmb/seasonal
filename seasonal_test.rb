require 'time'
require 'seasonal'
require 'test/unit'

class SeasonalTest < Test::Unit::TestCase

  def test_start_date
    e = Seasonal::Event.new(nil, 'America/New_York', 'jan 1')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year - 1, 12, 30, 23, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 1, 1, 17, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(Time.now.utc.year, 1, 2, 5, 0, 0)))
  end

  def test_start_date_end_time
    e = Seasonal::Event.new(nil,
      'America/New_York', 'feb 22', nil, nil, '5:00pm')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 4, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 13, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 2, 22, 22, 0, 1)))
  end

  def test_start_date_end_date
    e = Seasonal::Event.new(nil,
      'America/New_York', 'mar 3 2003', nil, 'mar 5 2003')

    assert_equal(false, e.going_on?(Time.utc(2003, 3, 3, 4, 59, 59)))

    assert(e.going_on?(Time.utc(2003, 3, 4, 0, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(2003, 3, 6, 5, 0, 0)))
  end

  def test_start_date_end_date_end_time
    e = Seasonal::Event.new(nil,
      'America/New_York', 'apr 20', nil, 'may 1', '00:00')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 4, 20, 3, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 5, 1, 0, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(Time.now.utc.year, 5, 2, 0, 0, 0)))
  end

  def test_start_date_start_time
    e = Seasonal::Event.new(nil, 'America/New_York', 'may 10', '10:00am')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 13, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 14, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 5, 10, 14, 0, 1)))
  end

  def test_start_date_start_time_end_time
    e = Seasonal::Event.new(nil,
      'America/New_York', 'june 22', '10:00am', nil, '10:30am')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 13, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 14, 15, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 6, 22, 14, 30, 1)))
  end

  def test_start_date_start_time_end_date
    e = Seasonal::Event.new(nil,
      'America/New_York', 'july 4', '11:00pm', 'jul 5')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 7, 5, 2, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 7, 5, 15, 0, 0)))

    assert_equal(false, e.going_on?(Time.utc(Time.now.utc.year, 7, 6, 4, 0, 0)))
  end

  def test_start_date_start_time_end_date_end_time
    e = Seasonal::Event.new(nil,
      'America/New_York', 'aug 19', '1:00pm', 'aug 21', '2:00pm')

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 8, 19, 16, 59, 59)))

    assert(e.going_on?(Time.utc(Time.now.utc.year, 8, 20, 15, 0, 0)))

    assert_equal(false,
      e.going_on?(Time.utc(Time.now.utc.year, 8, 21, 18, 0, 1)))
  end

end
