class SearchController < ApplicationController
def each_index
  @search = Product.search()
  @products = @search.result
end
