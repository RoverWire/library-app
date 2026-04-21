# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ['Action', 'Comedy', 'Drama', 'Horror'].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# ------------------------
# Clean DB
# ------------------------
Loan.delete_all
BookCopy.delete_all
Book.delete_all
Author.delete_all
Genre.delete_all
User.delete_all

# ------------------------
# Users
# ------------------------

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

genres =
  %w[
    Fantasy
    Science
    Fiction
    Mystery
    Thriller
    Romance
    Horror
    Biography
    History
    Philosophy
    Technology
  ].map do |name|
    Genre.create!(name: name)
  end

# ------------------------
# Authors
# ------------------------

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
# OVERDUE LOANS (vencidos)
# ------------------------

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

available_copies = BookCopy.where(status: :available).to_a

7.times do
  copy = BookCopy.all.sample
  next unless copy

  user = members.shuffle.find { |u| u.can_borrow?(copy.book) }
  next unless user

  borrowed_at = rand(20..60).days.ago
  due_date = borrowed_at + 14.days
  returned_at = due_date - rand(1..5).days

  Loan.create!(book_copy: copy, user: user, borrowed_at: borrowed_at, due_date: due_date, returned_at: returned_at)

  copy.update!(status: :available)
end
