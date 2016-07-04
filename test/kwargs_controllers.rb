# this file should not be loaded from Ruby <2.0

class KwBooksController < ApplicationController
  # keyword arguments
  def index(author_name, page: '1', q: nil)
    render plain: {author_name: author_name, page: page, q: q}.inspect
  end
end
