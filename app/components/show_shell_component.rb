# frozen_string_literal: true

class ShowShellComponent < ViewComponent::Base
  include Turbo::FramesHelper

  renders_one :extras

  def initialize(objects:)
    if objects.kind_of?(Array)
      @objects = objects
    else
      @objects = [objects]
    end

    @head_object = @objects.last
    @tail_objects = @objects[0..-2]
    @frame_id = "#{@head_object.class.name.underscore}_body".to_sym
  end

  def back_url
    if @tail_objects.empty?
      "/"
    else
      url_for(@tail_objects)
    end
  end
end
