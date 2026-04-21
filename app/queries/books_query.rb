# frozen_string_literal: true

class BooksQuery
  attr_reader :scope, :params

  FILTERS = %i[by_title by_author by_genre by_status by_isbn].freeze
  private_constant :FILTERS

  def self.call(params, scope = Book.all)
    new(scope, params: params).call
  end

  def initialize(scope = Book.all, params: {})
    @scope = scope
    @params = params
  end

  def call
    results =
      FILTERS.reduce(scope) do |s, filter|
        __send__(filter, s)
      end

    results.includes(:author, :genre)
  end

  # ------------------------
  # Filters
  # ------------------------

  def by_title(scope)
    return scope if params[:title].blank?

    scope.where('books.title ILIKE ?', "%#{params[:title]}%")
  end

  def by_author(scope)
    return scope if params[:author].blank?

    scope.joins(:author).where('authors.first_name ILIKE :q OR authors.last_name ILIKE :q', q: "%#{params[:author]}%")
  end

  def by_genre(scope)
    return scope if params[:genre].blank?

    scope.joins(:genre).where('genres.name ILIKE ?', "%#{params[:genre]}%")
  end

  def by_status(scope)
    return scope if params[:status].blank?

    scope.where(status: params[:status])
  end

  def by_isbn(scope)
    return scope if params[:isbn].blank?

    scope.where(isbn: params[:isbn])
  end
end
