# frozen_string_literal: true

class CreateBookCopies < ActiveRecord::Migration[8.1]
  def change
    create_table :book_copies, id: :uuid do |t|
      t.references :book, type: :uuid, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.text :annotations
      t.timestamps
    end
  end
end
