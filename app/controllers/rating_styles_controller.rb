class RatingStylesController < ApplicationController
  before_action :load_rating, only: %i[show edit update destroy preview]

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

  def preview
  end

  def create
    RatingStyle.transaction do
      style_params = rating_style_params
      new_args = style_params.without(:erb_source)
      @rating_style = RatingStyle.create!(new_args)
      respond_to do |format|
        if @rating_style.erb_source.attach(io: StringIO.new(style_params[:erb_source], 'r'),
                                           filename: "#{SecureRandom.uuid}.txt.erb",
                                           content_type: 'application/octet-stream',
                                           identify: false)
          format.html { redirect_to rating_style_path(@rating_style), notice: "Rating style #{@rating_style.name} was successfully created." }
          format.json { render :show, status: :created, location: @rating_style }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @rating_style.errors, status: :unprocessable_entity }
        end
      end
    end
  rescue => e
    logger.error(e.message)
    render :new, status: :unprocessable_entity
  end

  def update
    respond_to do |format|
      style_params = rating_style_params
      if style_params.key?(:erb_source)
        @rating_style.erb_source.attach(io: StringIO.new(style_params[:erb_source], 'r'),
                                        filename: "#{@rating_style.name.underscore}-format.txt.erb",
                                        content_type: 'text/vnd.mk2-fmt+erb')
        style_params = style_params.without(:erb_source)
      end
      if @rating_style.update(style_params)
        format.html { redirect_to rating_style_path(@rating_style) }
        format.json { render :show, status: :ok, location: @rating_style }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rating_style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rating_style.destroy!
    flash[:success] = "Rating style #{@rating_style.name} was successfully destroyed."
    respond_to do |format|
      format.turbo_stream { render }
      format.html { redirect_to rating_styles_path }
      format.json { head :no_content }
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
