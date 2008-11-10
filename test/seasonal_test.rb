$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'time'
require 'seasonal'
require 'test/unit'

class SeasonalTest < Test::Unit::TestCase

  def test_none
    e = Seasonal::Event.new(nil, 'America/New_York')

    assert_equal(false, e.going_on?)
  end

  def test_end
    es = 'mar 17'
    ennd = Time.parse(es).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :end => es)

    assert(e.going_on?(ennd - 1))
    assert(e.going_on?(ennd))
    assert_equal(false, e.going_on?(ennd + 1))
  end

  def test_start
    ss = 'jan 2'
    start = Time.parse(ss).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :start => ss)

    assert_equal(false, e.going_on?(start - 1))
    assert(e.going_on?(start))
    assert(e.going_on?(start + 1))
  end

  def test_start_end
    ss = 'aug 29'
    es = 'sep 1'
    start = Time.parse(ss).utc
    ennd = Time.parse(es).utc

    e = Seasonal::Event.new(nil, 'America/New_York', :start => ss, :end => es)

    assert_equal(false, e.going_on?(start - 1))

    if start <= ennd
      assert(e.going_on?(start))
      assert(e.going_on?(ennd))
    else
      assert_equal(false, e.going_on?(start))
      assert_equal(false, e.going_on?(ennd))
    end

    assert_equal(false, e.going_on?(ennd + 1))
  end

end
