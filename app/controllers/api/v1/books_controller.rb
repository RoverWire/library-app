# frozen_string_literal: true

module Api
  module V1
    class BooksController < Api::V1::ApplicationController
      before_action :set_book, only: %i[show update destroy]

      def index
        @books = BooksQuery.call(params)

        render json: @books, status: :ok
      end

      def show
        render json: @book, status: :ok
      end

      def create
        authorize! :create, Book

        book = Book.new(book_params)

        if book.save
          render json: book, status: :created
        else
          render_error(book)
        end
      end

      def update
        authorize! :update, @book

        if @book.update(book_params)
          render json: @book, status: :ok
        else
          render_error(@book)
        end
      end

      def destroy
        authorize! :destroy, @book

        @book.destroy
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.expect(book: %i[title isbn description author_id genre_id status])
      end
    end
  end
end
