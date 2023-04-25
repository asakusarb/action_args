# frozen_string_literal: true

# this file should not be loaded from Ruby <2.0

class KwBooksController < ApplicationController
  # keyword arguments
  def index(author_name, page: '1', q: nil)
    render plain: {author_name: author_name, page: page, q: q}.inspect
  end

  def show(id:)
    db = {'1' => 'nari'}
    author_name = db.fetch(id)

    render plain: {id: id, author_name: author_name}.inspect
  end
end
