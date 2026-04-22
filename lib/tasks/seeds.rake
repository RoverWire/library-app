# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc 'Seed development data'
    task development: :environment do
      load Rails.root.join('db', 'seeds', 'development.rb')
    end

    desc 'Seed production data'
    task production: :environment do
      load Rails.root.join('db', 'seeds', 'production.rb')
    end
  end
end
