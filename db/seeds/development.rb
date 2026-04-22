# frozen_string_literal: true

require 'faker'

# ------------------------
# Clean DB
# ------------------------
# Loan.delete_all
# BookCopy.delete_all
# Book.delete_all
# Author.delete_all
# Genre.delete_all
# User.delete_all

if Rails.env.development?
  puts 'Cleaning database (development)...' # rubocop:disable Rails/Output

  ActiveRecord::Base.connection.tables.each do |table|
    next if table == 'schema_migrations'

    ActiveRecord::Base.connection.execute("TRUNCATE #{table} RESTART IDENTITY CASCADE")
  end
end

# ------------------------
# Users
# ------------------------

puts 'Creating users...' # rubocop:disable Rails/Output

User.create!(email: 'admin@example.com', password: 'password123', first_name: 'Admin', last_name: 'User', role: :admin)

User.create!(email: 'librarian@example.com', password: 'password123', first_name: 'Libby', last_name: 'Smith', role: :librarian)

User.create!(email: 'member@example.com', password: 'password123', first_name: 'John', last_name: 'Doe', role: :member)

members =
  Array.new(5) do
    User.create!(email: Faker::Internet.unique.email, password: 'password123', first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, role: :member)
  end

# ------------------------
# Genres
# ------------------------

puts 'Creating genres...' # rubocop:disable Rails/Output

genres =
  %w[
    Biography
    Fantasy
    Fiction
    History
    Horror
    Mystery
    Philosophy
    Romance
    Science
    Technology
    Thriller
  ].map do |name|
    Genre.create!(name: name)
  end

# ------------------------
# Authors
# ------------------------

puts 'Creating authors...' # rubocop:disable Rails/Output

authors =
  Array.new(15) do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    gender = %w[Male Female Other].sample

    Author.create!(first_name: first_name, last_name: last_name, gender: gender, biography: Faker::Lorem.paragraph)
  end

# ------------------------
# Books + Copies
# ------------------------

puts 'Creating books and copies...' # rubocop:disable Rails/Output

50.times do
  author = authors.sample
  genre  = genres.sample

  book = Book.create!(title: Faker::Book.title, isbn: Faker::Code.unique.isbn, description: Faker::Lorem.paragraph(sentence_count: 3), author: author, genre: genre, status: :active)

  copies_count = rand(1..4)

  copies_count.times do
    BookCopy.create!(book: book, status: :available)
  end

  # Mantener consistencia con tu columna
  book.update!(copies_count: copies_count)
end

loans = []

# ------------------------
# ACTIVE LOANS
# ------------------------

puts 'Creating active loans...' # rubocop:disable Rails/Output

available_copies = BookCopy.where(status: :available).to_a

10.times do
  copy = available_copies.sample
  next unless copy

  user = members.shuffle.find { |u| u.can_borrow?(copy.book) }
  next unless user

  borrowed_at = rand(1..10).days.ago
  due_date = borrowed_at + 14.days

  next if due_date < Time.current

  loan = Loan.create!(book_copy: copy, user: user, borrowed_at: borrowed_at, due_date: due_date, returned_at: nil)

  copy.update!(status: :borrowed)

  loans << loan
  available_copies.delete(copy)
end

# ------------------------
# OVERDUE LOANS
# ------------------------

puts 'Creating overdue loans...' # rubocop:disable Rails/Output

available_copies = BookCopy.where(status: :available).to_a

8.times do
  copy = available_copies.sample
  next unless copy

  user = members.shuffle.find { |u| u.can_borrow?(copy.book) }
  next unless user

  borrowed_at = rand(20..40).days.ago
  due_date = borrowed_at + 14.days

  loan = Loan.create!(book_copy: copy, user: user, borrowed_at: borrowed_at, due_date: due_date, returned_at: nil)

  copy.update!(status: :borrowed)

  loans << loan
  available_copies.delete(copy)
end

# ------------------------
# RETURNED LOANS
# ------------------------

puts 'Creating returned loans history...' # rubocop:disable Rails/Output

loans_data = []

17.times do
  copy = BookCopy.all.sample
  next unless copy

  user = members.sample
  next unless user

  borrowed_at = rand(20..60).days.ago
  due_date = borrowed_at + 14.days
  returned_at = due_date - rand(1..5).days

  loans_data << {
    id: SecureRandom.uuid,
    book_copy_id: copy.id,
    user_id: user.id,
    borrowed_at: borrowed_at,
    due_date: due_date,
    returned_at: returned_at,
    created_at: borrowed_at,
    updated_at: returned_at || borrowed_at
  }
end

Loan.insert_all(loans_data)

puts 'Done!' # rubocop:disable Rails/Output
