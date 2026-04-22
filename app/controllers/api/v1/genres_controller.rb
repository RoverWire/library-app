# frozen_string_literal: true

module Api
  module V1
    class GenresController < Api::V1::ApplicationController
      before_action :set_genre, only: %i[show update destroy]

      def index
        genres = Genre.all

        render json: genres, status: :ok
      end

      def show
        render json: @genre, status: :ok
      end

      def create
        authorize! :create, Genre

        genre = Genre.new(genre_params)

        if genre.save
          render json: genre, status: :created
        else
          render_error(genre)
        end
      end

      def update
        authorize! :update, @genre

        if @genre.update(genre_params)
          render json: @genre, status: :ok
        else
          render_error(@genre)
        end
      end

      def destroy
        authorize! :destroy, @genre

        @genre.destroy
        head :no_content
      end

      private

      def set_genre
        @genre = Genre.find(params[:id])
      end

      def genre_params
        params.expect(genre: %i[name])
      end
    end
  end
end
