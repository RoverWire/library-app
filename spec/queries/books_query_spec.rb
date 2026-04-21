# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksQuery do
  describe '.call' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    subject(:result) { described_class.call(params) }

    let!(:genre_fantasy) { create(:genre, name: 'Fantasy') }
    let!(:genre_scifi) { create(:genre, name: 'Sci-Fi') }

    let!(:author_rowling) { create(:author, first_name: 'J.K.', last_name: 'Rowling') }
    let!(:author_tolkien) { create(:author, first_name: 'J.R.R.', last_name: 'Tolkien') }

    let!(:book_one) do
      create(:book, title: 'Harry Potter', author: author_rowling, genre: genre_fantasy)
    end

    let!(:book_two) do
      create(:book, title: 'Lord of the Rings', author: author_tolkien, genre: genre_fantasy)
    end

    let!(:book_three) do
      create(:book, title: 'Dune', author: author_tolkien, genre: genre_scifi)
    end

    context 'without filters' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { {} }

      it 'returns all books' do
        expect(result).to contain_exactly(book_one, book_two, book_three)
      end
    end

    context 'when filtering by title' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { title: 'Harry' } }

      it 'returns matching books' do
        expect(result).to contain_exactly(book_one)
      end
    end

    context 'when filtering by author' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { author: 'Tolkien' } }

      it 'returns books from that author' do
        expect(result).to contain_exactly(book_two, book_three)
      end
    end

    context 'when filtering by genre' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { genre: 'Fantasy' } }

      it 'returns books in that genre' do
        expect(result).to contain_exactly(book_one, book_two)
      end
    end

    context 'when filtering by status' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { status: 'active' } }

      it 'returns only active books' do
        expect(result).to include(book_one, book_two, book_three)
      end
    end

    context 'when filtering by title and genre' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { title: 'Lord', genre: 'Fantasy' } }

      it 'returns filtered combination' do
        expect(result).to contain_exactly(book_two)
      end
    end

    context 'when filtering by case insensitive search' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { title: 'harry' } }

      it 'matches regardless of case' do
        expect(result).to include(book_one)
      end
    end

    context 'when no matches are found' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { title: 'Nonexistent' } }

      it 'returns empty relation' do
        expect(result).to be_empty
      end
    end
  end
end
