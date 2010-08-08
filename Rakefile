require 'rake'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "action_throttler"
    s.version = "0.1.0"
    s.summary = "Action Throttler is an easy to use Rails plugin to quickly throttle application actions based on configurable duration and limit."
    s.description = "Action Throttler is an easy to use Rails plugin to quickly throttle application actions based on configurable duration and limit."
    s.email = "ifredwu@gmail.com"
    s.homepage = "http://github.com/fredwu/action_throttler"
    s.authors = ["Fred Wu"]
    s.add_dependency("activerecord")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end