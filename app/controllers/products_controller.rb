class ProductsController < ApplicationController
  
  def index
    if params[:search].present?
      search_param = params[:search].to_s.strip
      if search_param.match?(/^\d+$/) && search_param.to_i > 0
        begin
          @product = Product.find(params[:search])
          @product.price /= 2 if @product.branch.downcase.gsub(/[^a-z]/i, '').reverse == @product.branch.downcase.gsub(/[^a-z]/i, '')
          return render :json => @product, status: 200
        rescue ActiveRecord::RecordNotFound
          @products = Product.searchs(params[:search])
        end
      else
        @products = Product.searchs(params[:search])
      end
    else
      @products = Product.all
    end
  
    @products.each do |product|
      product.price /= 2 if product.branch.downcase.gsub(/[^a-z]/i, '').reverse == product.branch.downcase.gsub(/[^a-z]/i, '')
    end
  
    render :json => @products, status: 200
  end
  
end
  