require File.dirname(__FILE__) + "/rake_helper"

module ActionThrottler
  class Tasks
    include ActionThrottler::Rake
    
    def self.run!
      namespace :action_throttler do
        desc "Generates the Action Throttler initializer file"
        task :init => :environment do
          copy_initializer_file "The Action Throttler initializer file has been generated."
        end
        
        desc "Generates the Action Throttler database migration file"
        task :migrate => :init do
          copy_migration_file "The Action Throttler migration file has been generated."
        end
        
        desc "Generates the Action Throttler database migration file and migrates the database"
        task :auto_migrate => :migrate do
          ::Rake::Task["db:migrate"].invoke
        end
      end
    end
  end
end

ActionThrottler::Tasks.run!