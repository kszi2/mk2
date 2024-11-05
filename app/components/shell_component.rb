# frozen_string_literal: true

class ShellComponent < ViewComponent::Base
  include Turbo::FramesHelper

  attr_reader :head_object
  attr_reader :tail_objects
  attr_reader :frame_id
  attr_reader :full_objects

  def initialize(objects:)
    if objects.kind_of?(Array)
      @full_objects = objects
    else
      @full_objects = [objects]
    end

    @head_object = @full_objects.last
    @tail_objects = @full_objects[0..-2]
    @frame_id = "#{@head_object.class.name.underscore}_body".to_sym
  end

  def do_breadcrumbs
    content_tag :div, class: "mb-4" do
      render BreadcrumbsComponent.new(path: @full_objects)
    end
  end

  def shell_body(breadcrumbs: true, &block)
    if breadcrumbs
      do_breadcrumbs + turbo_frame_tag(@frame_id, &block)
    else
      turbo_frame_tag(@frame_id, &block)
    end
  end

  def resource_controls
    content_tag :div, class: "mt-4" do
      render ResourceControlsComponent.new(back: back_url)
    end
  end

  def back_url
    # Return parent objects' path if they exist, otherwise the index page on the
    # current object's type
    if @tail_objects.empty?
      url_for(controller: @head_object.class.name.underscore.pluralize, action: :index)
    else
      url_for(@tail_objects)
    end
  end
end
