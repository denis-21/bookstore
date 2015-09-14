class CategoriesController < ApplicationController
  load_and_authorize_resource :only => [:show]
  layout 'layouts/books_aplication'

  def show
    @books = @category.books.page(params[:page])
  end

end
