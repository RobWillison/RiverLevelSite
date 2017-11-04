class AddSmsEnabledFlag < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sms_enabled, :boolean
  end
end
