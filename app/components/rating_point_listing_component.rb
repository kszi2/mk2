# frozen_string_literal: true

class RatingPointListingComponent < ViewComponent::Base
  include Inputs
  with_collection_parameter :rating_point

  def initialize(rating_point:, fade: false)
    raise ArgumentError unless rating_point.is_a?(RatingPoint)

    @rating_point = rating_point
    @fade = fade
  end

  def fade_in_class
    return "" unless @fade
    "animate-opacity-appear"
  end

  def view_url
    url_for([*parent_objects, @rating_point])
  rescue
    logger.error("Unknown view path for #{@note}")
    "#"
  end

  def edit_url
    url_for([:edit, *parent_objects, @rating_point])
  rescue
    logger.error("Unknown edit path for #{@note}")
    "#"
  end

  def destroy_url
    url_for([*parent_objects, @rating_point])
  rescue
    logger.error("Unknown destroy path for #{@note}")
    "#"
  end

  private

  def parent_objects
    cw = @rating_point.coursework
    course = cw.course
    [course, cw]
  end
end
