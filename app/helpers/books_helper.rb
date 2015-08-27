module BooksHelper

  def exist_in_wish_list(book)
    if user_signed_in?
      unless current_user.book_in_wishlist?(book)
        link_to raw('<span class="glyphicon glyphicon-plus"></span> <span>Add to Wishlist</span>'),wish_list_book_path,
                method: :post, class: "btn wish_list text-info "
      else
        link_to raw('<span>In wish list</span>'),wish_list_books_path, class: "btn wish_list text-warning "
      end
    end
  end

end
