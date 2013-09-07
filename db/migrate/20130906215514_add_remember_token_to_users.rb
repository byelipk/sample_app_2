class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
  	# Add column to the users table called remember_token 
  	# whose data type is a string
    add_column :users, :remember_token, :string
    # Add an index to the users table on the column remember_token
    add_index  :users, :remember_token
  end
end
