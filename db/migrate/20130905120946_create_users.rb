class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # Creates 5 columns in total

      # the ID is created automatically
      t.string :name
      t.string :email

      # created_at & updated_at are combined into t.timestamp
      t.timestamps
    end
  end
end
