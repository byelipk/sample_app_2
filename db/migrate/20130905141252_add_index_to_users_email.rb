class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # We generate this migration to eliminate the need for a full
    # table scan, and to assure that there can only be one
    # unique email in the database, thus preventing duplicate entries.
    add_index :users, :email, unique: true
  end
end
