# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :request do
  let(:headers) { authenticate_as(:member) }
  let(:headers_librarian) { authenticate_as(:librarian) }

  let!(:author) { create(:author) }
  let!(:genre)  { create(:genre) }

  let!(:book) do
    create(:book, title: 'Dune', author: author, genre: genre)
  end

  let(:valid_params) do
    {
      book: {
        title: 'New Book',
        isbn: '1234567890',
        description: 'Test book',
        author_id: author.id,
        genre_id: genre.id,
        status: 'active'
      }
    }
  end

  describe 'GET /index' do
    it 'returns ok' do
      get '/api/v1/books', headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns books' do
      get '/api/v1/books', headers: headers

      json = response.parsed_body

      expect(json.first['title']).to eq('Dune')
    end
  end

  describe 'GET /show' do
    it 'returns book' do
      get "/api/v1/books/#{book.id}", headers: headers

      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['title']).to eq('Dune')
    end
  end

  describe 'POST /create' do
    context 'when authorized (librarian/admin)' do
      let(:role) { :librarian }

      it 'creates book' do
        expect { post '/api/v1/books', params: valid_params, headers: headers_librarian }
          .to change(Book, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'when unauthorized (member)' do
      let(:role) { :member }

      it 'returns forbidden' do
        post '/api/v1/books', params: valid_params, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid params' do
      let(:role) { :librarian }

      it 'returns unprocessable entity' do
        post '/api/v1/books', params: { book: { title: '' } }, headers: headers_librarian

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /update' do
    context 'when authorized' do
      let(:role) { :librarian }

      it 'updates book' do
        put "/api/v1/books/#{book.id}", params: { book: { title: 'Updated' } }, headers: headers_librarian

        expect(response).to have_http_status(:ok)
        expect(book.reload.title).to eq('Updated')
      end
    end

    context 'when unauthorized' do
      let(:role) { :member }

      it 'returns forbidden' do
        put "/api/v1/books/#{book.id}", params: { book: { title: 'Hack' } }, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when authorized' do
      let(:role) { :librarian }

      it 'deletes book' do
        delete "/api/v1/books/#{book.id}", headers: headers_librarian

        expect(response).to have_http_status(:no_content)
        expect(Book.exists?(book.id)).to be false
      end
    end

    context 'when unauthorized' do
      let(:role) { :member }

      it 'returns forbidden' do
        delete "/api/v1/books/#{book.id}", headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
