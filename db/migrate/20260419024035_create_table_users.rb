# frozen_string_literal: true

class CreateTableUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :role, default: 0, null: false, index: true
    end
  end
end
