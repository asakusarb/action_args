# this file should not be loaded from Ruby <2.1

class KwKeyreqBooksController < ApplicationController
  # keyword arguments
  def index(author_name:, page: '1', q: nil)
    render text: {author_name: author_name, page: page, q: q}.inspect
  end
end
