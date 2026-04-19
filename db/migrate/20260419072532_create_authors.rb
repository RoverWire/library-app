# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :gender
      t.text :biography
      t.timestamps
    end

    add_index :authors, %i[first_name last_name], unique: true
  end
end
