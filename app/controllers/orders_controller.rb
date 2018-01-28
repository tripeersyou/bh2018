class OrdersController < ApplicationController
    before_action :set_seller, except: [:index, :order, :show]
    def index
        if buyer_signed_in?
            @orders = Order.all.where(buyer_id: current_buyer.id)            
        else
            @orders = Order.all.where(seller: current_seller)
        end
    end
    def show
        @order = Order.find(params[:id])
    end
    def new
        @order = current_buyer.orders.new
    end
    def create
        @order = current_buyer.orders.new(order_params)
        @order.seller_id = @seller.id
        if @order.save
            @order.order_lines.each do |ol|
                product = ol.product
                product.quantity -= ol.quantity
                product.save
            end
            redirect_to order_path(@order)
        else
            render :new
        end
    end
    private
        def order_params
            params.require(:order).permit!
        end
        def set_seller
           @seller = Seller.find(params[:seller_id]) 
        end
end
