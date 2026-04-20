# frozen_string_literal: true

class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table :loans, id: :uuid do |t|
      t.references :user, type: :bigint, null: false, foreign_key: true
      t.references :book_copy, type: :uuid, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.datetime :due_date, null: false
      t.datetime :returned_at # null if not returned yet

      t.timestamps
    end
  end
end
