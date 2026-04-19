# frozen_string_literal: true

class CreateGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :genres, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :genres, :name, unique: true
  end
end
