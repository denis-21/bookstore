class CategoriesController < ApplicationController
  load_and_authorize_resource
  layout 'layouts/books_aplication'
  def show
    @category = Category.find(params[:id])
    @books = @category.books.page(params[:page])
  end

end
