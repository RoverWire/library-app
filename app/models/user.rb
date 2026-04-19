# frozen_string_literal: true

class User < ApplicationRecord
  enum :role, { member: 0, admin: 1, librarian: 2 }
end
