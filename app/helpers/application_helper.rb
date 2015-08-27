module ApplicationHelper

  def all_categories
    Category.all.order('name ASC')
  end

end
