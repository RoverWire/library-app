# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title, null: false
      t.string :isbn, null: false
      t.integer :status, default: 1, null: false
      t.text :description
      t.integer :copies_count, default: 0, null: false

      t.references :author, type: :uuid, null: false, foreign_key: true
      t.references :genre, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :books, :isbn, unique: true
  end
end
