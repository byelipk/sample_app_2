class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    # We've generated a migration in the command line
    # and specified that we want to add a new column
    # called password_digest
    add_column :users, :password_digest, :string
  end
end
