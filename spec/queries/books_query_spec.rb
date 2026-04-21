# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksQuery do
  describe '.call' do
    subject(:result) { described_class.call(params) }

    let!(:fantasy) { create(:genre, name: 'Fantasy') }
    let!(:scifi)   { create(:genre, name: 'Sci-Fi') }

    let!(:rowling) { create(:author, first_name: 'J.K.', last_name: 'Rowling') }
    let!(:tolkien) { create(:author, first_name: 'J.R.R.', last_name: 'Tolkien') }

    let!(:book_one) { create(:book, title: 'Harry Potter', author: rowling, genre: fantasy) }
    let!(:book_two) { create(:book, title: 'Lord of the Rings', author: tolkien, genre: fantasy) }
    let!(:book_three) { create(:book, title: 'Dune', author: tolkien, genre: scifi) }

    context 'without filters' do
      let(:params) { {} }

      it 'returns all books' do
        expect(result).to contain_exactly(book_one, book_two, book_three)
      end
    end

    context 'when filtering by title' do
      let(:params) { { title: 'Harry' } }

      it 'returns matching books' do
        expect(result).to contain_exactly(book_one)
      end
    end

    context 'when filtering by author' do
      let(:params) { { author: 'Tolkien' } }

      it 'returns books from that author' do
        expect(result).to contain_exactly(book_two, book_three)
      end
    end

    context 'when filtering by genre' do
      let(:params) { { genre: 'Fantasy' } }

      it 'returns books in that genre' do
        expect(result).to contain_exactly(book_one, book_two)
      end
    end

    context 'when filtering by status' do
      let(:params) { { status: 'active' } }

      it 'returns only active books' do
        expect(result).to include(book_one, book_two, book_three)
      end
    end

    context 'when filtering by title and genre' do
      let(:params) { { title: 'Lord', genre: 'Fantasy' } }

      it 'returns filtered combination' do
        expect(result).to contain_exactly(book_two)
      end
    end

    context 'when filtering by case insensitive search' do
      let(:params) { { title: 'harry' } }

      it 'matches regardless of case' do
        expect(result).to include(book_one)
      end
    end

    context 'when no matches are found' do
      let(:params) { { title: 'Nonexistent' } }

      it 'returns empty relation' do
        expect(result).to be_empty
      end
    end
  end
end
