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
    style_params = rating_style_params
    new_args = style_params.without(:erb_source)
    @rating_style = RatingStyle.new(new_args)
    save_succ = @rating_style.save!
    logger.info("saved #{@rating_style}")
    blob = ActiveStorage::Blob.create_and_upload!(io: StringIO.new(style_params[:erb_source], 'r'),
                                                  filename: "#{SecureRandom.uuid}.txt.erb",
                                                  content_type: 'application/octet-stream',
                                                  identify: false)
    logger.info("uploaded blob #{blob.signed_id}")
    respond_to do |format|
      if save_succ && @rating_style.erb_source.attach(blob)
        format.html { redirect_to rating_style_path(@rating_style), notice: "Rating style #{@rating_style.name} was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
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
