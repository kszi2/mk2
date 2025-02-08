# frozen_string_literal: true

class DataTableComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Inputs

  renders_one :table_actions
  renders_one :row_actions

  attr_reader :current_object

  def initialize(objects:, col_config:, type:, parents: [], filters: {}, inline_create: false)
    @objects = objects
    @col_config = col_config
    @type = type
    @parents = parents
    @filters = filters
    @inline_create = inline_create
  end

  private

  attr_writer :current_object

  def nth_th(idx, cfg = {})
    return "border-t border-l text-semibold" if idx == 0
    if cfg.has_key?(:hide)
      hide = cfg[:hide]
      # sm:table-cell md:table-cell lg:table-cell xl:table-cell
      "hidden #{hide}:table-cell border-t"
    else
      "border-t"
    end
  end

  def nth_td(idx, cfg = {})
    return "font-semibold border-l border-wa-neutral-border-normal" if idx == 0
    if cfg.has_key?(:hide)
      hide = cfg[:hide]
      "hidden #{hide}:table-cell"
    else
      ""
    end
  end

  def data_turbo_location
    return { } if @inline_create
    { turbo_frame: "_top" }
  end

  def header_name(cfg)
    return cfg[:name] if cfg.has_key?(:name)
    cfg[:field].to_s.humanize
  end

  def value_of(obj, cfg)
    renderer = cfg[:render_with]
    if renderer && renderer.is_a?(Proc)
      return renderer.call(obj)
    end

    field = cfg[:field]
    raise ArgumentError, "Unknown field for object of type #{obj.class.name}: #{field}" unless obj.respond_to?(field)
    top = obj.send(field)
    if top.nil?
      cfg[:default]
    elsif renderer && top.respond_to?(renderer)
      top.send(renderer)
    else
      top
    end
  end

  def full_obj_path(obj)
    @parents + [obj]
  end

  def identify_obj(obj)
    if obj.respond_to?(:name)
      obj.class.name + " " + obj.name
    else
      "this " + obj.class.name
    end
  end
end
