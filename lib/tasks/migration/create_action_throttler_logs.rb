class CreateActionThrottlerLogs < ActiveRecord::Migration
  def self.up
    create_table :action_throttler_logs, :force => true do |t|
      t.string :scope
      t.string :reference
      t.timestamps
    end
	
    add_index :action_throttler_logs, :scope
    add_index :action_throttler_logs, :reference
    add_index :action_throttler_logs, [:scope, :reference]
  end
  
  def self.down
    drop_table :action_throttler_logs
  end
end