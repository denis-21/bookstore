class RatingsController < ApplicationController
  load_resource :book
  load_and_authorize_resource

  def new

  end

  def create
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
