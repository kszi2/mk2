# frozen_string_literal: true

class Shells::ShellComponent < ViewComponent::Base
  include Turbo::FramesHelper

  attr_reader :head_object
  attr_reader :tail_objects
  attr_reader :frame_id
  attr_reader :full_objects
  attr_accessor :do_breadcrumbs

  def initialize(objects:, do_frame: true, do_breadcrumbs: true, **opts)
    if objects.kind_of?(Array)
      @full_objects = objects
    else
      @full_objects = [objects]
    end

    @head_object = @full_objects.last
    @tail_objects = @full_objects[0..-2]
    @frame_id = "#{@head_object.class.name.underscore}_body".to_sym
    @do_frame = do_frame
    @do_breadcrumbs = do_breadcrumbs
    @opts = opts
  end

  def shell_body(&block)
    do_breadcrumbs + do_frame_tag(&block)
  end

  def resource_controls
    content_tag :div, class: "mt-4" do
      render ResourceControlsComponent.new(back: back_url)
    end
  end

  def back_url
    if @tail_objects.empty?
      url_for(controller: @head_object.class.name.pluralize.underscore, action: :index)
    else
      url_for(@tail_objects)
    end
  end

  protected

  def option(key) = @opts[key]

  private

  def do_frame_tag(&block)
    if @do_frame
      turbo_frame_tag(@frame_id, &block)
    else
      content_tag(:div, &block)
    end
  end

  def do_breadcrumbs
    if @do_breadcrumbs
      content_tag :div, class: "mb-4" do
        render BreadcrumbsComponent.new(path: @full_objects)
      end
    else
      tag :div do
      end
    end
  end
end
