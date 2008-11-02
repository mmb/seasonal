require 'seasonal'

c = Seasonal::Calendar.new

c.push(Seasonal::Event.new(
  'autumn', 'America/New_York', 'sep 21', nil, 'dec 21'))
c.push(Seasonal::Event.new(
  'late night', 'America/New_York', nil, '10:00 pm', nil, '11:59 pm'))
c.push(Seasonal::Event.new(
  "Matt's birthday", 'America/New_York', 'june 22'))
c.push(Seasonal::Event.new(
  "Christmas", 'America/New_York', 'dec 25'))

puts "currently going on:"
c.going_on { |e| puts e.payload }
