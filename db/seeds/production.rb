# frozen_string_literal: true

puts 'Seeding production database...' # rubocop:disable Rails/Output

User.find_or_create_by!(email: 'admin@library.com') do |user|
  user.password = ENV.fetch('ADMIN_PASSWORD', 'change_me')
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.role = :admin
end

genres = [
  'Adventure',
  'Anthology',
  'Art',
  'Biography',
  'Business',
  'Children',
  'Classic Literature',
  'Comics',
  'Contemporary Fiction',
  'Cooking',
  'Cyberpunk',
  'Design',
  'Drama',
  'Dystopian',
  'Economics',
  'Espionage',
  'Essays',
  'Fantasy',
  'Fitness',
  'Graphic Novels',
  'Health',
  'Historical Fiction',
  'History',
  'Horror',
  'Mathematics',
  'Memoir',
  'Music',
  'Mystery',
  'Philosophy',
  'Photography',
  'Poetry',
  'Politics',
  'Post-Apocalyptic',
  'Programming',
  'Religion',
  'Romance',
  'Satire',
  'Science Fiction',
  'Science',
  'Self-Help',
  'Short Stories',
  'Sports',
  'Steampunk',
  'Technology',
  'Thriller',
  'Travel',
  'True Crime',
  'War',
  'Western',
  'Young Adult'
]

genres.each do |name|
  Genre.find_or_create_by!(name: name)
end

puts 'Production database seeded successfully!' # rubocop:disable Rails/Output
