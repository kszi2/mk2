class RatingStylesController < ApplicationController
  before_action :load_rating, only: %i[show edit update destroy]
  before_action :create_new_rating, only: %i[create]

  def new
    @rating_style = RatingStyle.new
  end

  def index
    @rating_styles = RatingStyle.page(params[:page]).per(params[:per_page] || 25)
  end

  def show
  end

  def edit
  end

  def create
    @rating_style = RatingStyle.new(rating_style_params)
    respond_to do |format|
      if @rating_style.save
        format.html { redirect_to rating_style_path(@rating_style), notice: "Rating style #{@rating_style.name} was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rating_style.update(rating_style_params)
        format.html { redirect_to rating_style_path(@rating_style) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rating_style.destroy!
    flash[:success] = "Rating style #{@rating_style.name} was successfully destroyed."
    respond_to do |format|
      format.turbo_stream { render }
      format.html { redirect_to rating_styles_path }
    end
  end

  private

  def rating_style_params
    params.require(:rating_style).permit(:name, :erb_source)
  end

  def load_rating
    id = params.require(:id)
    @rating_style = RatingStyle.find(id)
  end
end
