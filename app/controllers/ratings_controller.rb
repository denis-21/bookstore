class RatingsController < ApplicationController
  load_and_authorize_resource

  def new
    @book = Book.find(params[:book_id])
    @rating = Rating.new

  end

  def create
    @book = Book.find(params[:book_id])
    @rating = @book.ratings.create(rating_params)
    @rating.user = current_user
    if @rating.save
      flash[:success] = "Your review is awaiting moderation."
      redirect_to book_url(@book)
    else
      render :new
    end

  end

  private
    def rating_params
      params.require(:rating).permit(:rating, :review)
    end

end
