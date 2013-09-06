class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # We've generated a migration in the command line
    # and specified that we want to add an index
    # on the email column
    # We do this to assure that there can only be one
    # unique email in the database. This way we can prevent duplicate entries.
    # NOTE: In the event a second email is submitted,
    # the second save will fail and raise an ActiveRecord exception
    add_index :users, :email, unique: true
  end
end
