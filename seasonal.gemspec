Gem::Specification.new do |s|
  s.name     = "seasonal"
  s.version  = "0.0.7"
  s.date     = "2009-01-15"
  s.summary  = "create logic based on defined date and time events"
  s.email    = "matthewm@boedicker.org"
  s.homepage = "http://github.com/mmb/seasonal"
  s.description = "Create a calendar of date and time events and execute code based on which events are currently happening."
  s.has_rdoc = false
  s.authors  = ["Matthew M. Boedicker"]
  s.files    = [
    "lib/seasonal.rb",
    "README.textile",
    "seasonal.gemspec",
    ]
  s.test_files = [
    "test/seasonal_test.rb",
    ]
  s.add_dependency("tzinfo", ["> 0.0.0"])
end
