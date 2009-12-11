require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec)
task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "getter_for"
    gemspec.summary = "Adds getter methods for attributes that the object belongs to"
    gemspec.description = "Generates convenience methods especially for use in views like [ticket.user_name] instead of [ticket.user.name if ticket.user]"
    gemspec.email = "m.linkhorst@googlemail.com"
    gemspec.homepage = "http://github.com/linki/getter_for"
    gemspec.authors = ["Martin Linkhorst"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end