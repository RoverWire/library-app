# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :books, :title
    add_index :books, :status

    add_index :book_copies, :status

    add_index :loans, :returned_at
    add_index :loans, :due_date
    add_index :loans, %i[user_id returned_at]
    add_index :loans, %i[book_copy_id returned_at], name: 'index_loans_on_copy_active'
  end
end
