module PaginationHelper
  # @param pagination [Hash] Pagination metadata from the controller
  # @param path [string] The url string we are generating for the links
  # @param param [Symbol] The "page" param used to configure pagination in the links. This will almost always be "page".
  #   The exception is when we have multiple paginated lists on a single view, like we do in products/show. In that case
  #   we can pass in an exception to overwrite the default value set here.
  #
  def pagination_links(pagination, path:, param: :page)
    return if pagination[:total_pages] <= 1

    links = []

    if pagination[:prev_page]
      links << link_to("Previous", "#{path}?#{param}=#{pagination[:prev_page]}")
    end

    if pagination[:next_page]
      links << link_to("Next", "#{path}?#{param}=#{pagination[:next_page]}")
    end

    content_tag(:nav, class: "pagination") do
      safe_join([
        content_tag(:span, "Total: #{pagination[:total_count]}"),
        content_tag(:span, "Page #{pagination[:current_page]} of #{pagination[:total_pages]}"),
        safe_join(links, " | ")
      ], " | ")
    end
  end
end
