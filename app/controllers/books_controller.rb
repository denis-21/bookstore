class BooksController < ApplicationController
  load_and_authorize_resource
  layout 'layouts/books_aplication'

  def index
    if params[:search]
      @books = @books.search(params[:search]).page(params[:page])
    else
      @books = @books.page(params[:page])
    end
  end

  def show
    @ratings = @book.ratings.approved
  end

  def wishlist
    @books = current_user.books.page(params[:page])
  end

  def add_to_wishlist
    unless current_user.book_in_wishlist?(@book)
      current_user.add_to_wishlist(@book)
      flash[:success] = 'This book successfully added to Wish list'
    else
      flash[:danger] = 'Book already exists at Wish list'
    end
    redirect_to book_path(@book)
  end

  def delete_from_wishlist
    if current_user.book_in_wishlist?(@book)
      current_user.delete_from_wishlist(@book)
      flash[:warning] = "#{@book.title} successfully removed from Wish list"
    else
      flash[:danger] = 'Book is not at Wish list'
    end
    redirect_to wish_list_books_path
  end

end
