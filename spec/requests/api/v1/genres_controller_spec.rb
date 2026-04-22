# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :request do
  let!(:genre) { create(:genre, name: 'Fantasy') }

  let(:valid_params) do
    {
      genre: {
        name: 'Sci-Fi'
      }
    }
  end

  let(:invalid_params) do
    {
      genre: {
        name: ''
      }
    }
  end

  describe 'GET /api/v1/genres' do
    let(:headers) { authenticate_as(:member) }

    it 'returns ok' do
      get '/api/v1/genres', headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns genres' do
      get '/api/v1/genres', headers: headers

      json = response.parsed_body

      expect(json.first['name']).to eq('Fantasy')
    end
  end

  describe 'GET /api/v1/genres/:id' do
    let(:headers) { authenticate_as(:member) }

    it 'returns genre' do
      get "/api/v1/genres/#{genre.id}", headers: headers

      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['name']).to eq('Fantasy')
    end
  end

  describe 'POST /api/v1/genres' do
    context 'when authorized (librarian)' do
      let(:headers) { authenticate_as(:librarian) }

      it 'creates genre' do
        expect { post '/api/v1/genres', params: valid_params, headers: headers }
          .to change(Genre, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when authorized (admin)' do
      let(:headers) { authenticate_as(:admin) }

      it 'creates genre' do
        expect { post '/api/v1/genres', params: valid_params, headers: headers }
          .to change(Genre, :count).by(1)
      end
    end

    context 'when unauthorized (member)' do
      let(:headers) { authenticate_as(:member) }

      it 'returns forbidden' do
        post '/api/v1/genres', params: valid_params, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid params' do
      let(:headers) { authenticate_as(:librarian) }

      it 'returns unprocessable entity' do
        post '/api/v1/genres', params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /api/v1/genres/:id' do
    context 'when authorized' do
      let(:headers) { authenticate_as(:librarian) }

      it 'updates genre' do
        put "/api/v1/genres/#{genre.id}", params: { genre: { name: 'Updated' } }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(genre.reload.name).to eq('Updated')
      end
    end

    context 'when unauthorized' do
      let(:headers) { authenticate_as(:member) }

      it 'returns forbidden' do
        put "/api/v1/genres/#{genre.id}", params: { genre: { name: 'Hack' } }, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid params' do
      let(:headers) { authenticate_as(:librarian) }

      it 'returns unprocessable entity' do
        put "/api/v1/genres/#{genre.id}", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /api/v1/genres/:id' do
    context 'when authorized' do
      let(:headers) { authenticate_as(:librarian) }

      it 'deletes genre' do
        delete "/api/v1/genres/#{genre.id}", headers: headers

        expect(response).to have_http_status(:no_content)
        expect(Genre.exists?(genre.id)).to be false
      end
    end

    context 'when unauthorized' do
      let(:headers) { authenticate_as(:member) }

      it 'returns forbidden' do
        delete "/api/v1/genres/#{genre.id}", headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
