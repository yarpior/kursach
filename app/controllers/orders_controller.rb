class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  def search
    @orders_for_categories = Order.all()
    if request.method == 'GET'
      render 'search/search'
    elsif request.method == 'POST'
      @orders = Order.search(params)
      render 'search/search'
    end   
  end
  
  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.build_tariff
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    set_or_create_tariff(@order, order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Заказ успешно создан.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Заказ успешно обновлен.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Заказ успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_or_create_tariff(order, params)
      if params[:tariff_id].blank?
        order.tariff = Tariff.create(params[:tariff_attributes])
        order.tariff_id = order.tariff.id
      else
        order.tariff = Tariff.find(params[:tariff_id])
      end
    end 
   






    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:tariff_id, :car_id, :date_of_order, :time_of_order, :departure_address, :end_address, :passengers, :distance, 
tariff_attributes: [:_destroy, :id, :name, :times_of_day, :range, :ppk])
    end
end
