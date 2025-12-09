module Paginatable
  extend ActiveSupport::Concern

  PER_PAGE = 20

  class_methods do
    def paginate(page:)
      page = [page.to_i, 1].max
      total_count = count
      total_pages = (total_count.to_f / PER_PAGE).ceil
      offset = (page - 1) * PER_PAGE

      {
        records: limit(PER_PAGE).offset(offset),
        total_count: total_count,
        current_page: page,
        total_pages: total_pages,
        prev_page: page > 1 ? page - 1 : nil,
        next_page: page < total_pages ? page + 1 : nil
      }
    end
  end
end
