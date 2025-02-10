# frozen_string_literal: true

class Inputs::ButtonComponent < ViewComponent::Base
  include Sizable

  SupportedTypes = %i[basic primary secondary cancel destroy]

  renders_one :prefix

  def initialize(type:, text:, href:, size: :medium, enabled: true, id: nil, name: nil, data: {}, button_type: nil, rounding: :all)
    @type = type
    @text = text
    @href = href
    @size = size
    @data = data
    @enabled = enabled
    @rounding = rounding
    @name = name || (text.present? ? text.underscore : nil)
    @id = id || object_id
    @button_type = button_type
  end

  def real_content
    return content if content?
    @text
  end

  def button_type
    return {} if @button_type.nil?
    { type: @button_type }
  end

  def true_button?
    return true unless @enabled
    @href.nil?
  end

  def rounding_styles
    case @rounding
    when :all
      'border rounded'
    when :grouped
      "border first:rounded-l last:rounded-r first:border-r-0 last:border-l-0"
    when :no_border
      ""
    else
      raise ArgumentError, "unexpected button rounding type #{@rounding}: expected #{[:all, :grouped, :no_border]}"
    end
  end

  def color_styles
    case @type
    when :basic
      'text-wa-text-normal bg-wa-surface-raised border-wa-surface-border' +
        ' hover:bg-wa-surface-default active:bg-wa-surface-lowered'
    when :primary
      'text-wa-brand-on-loud bg-wa-brand-fill-loud border-wa-brand-border-loud' +
        ' hover:bg-wa-brand-fill-normal active:bg-wa-brand-fill-quiet' +
        ' hover:border-wa-brand-border-normal active:border-wa-brand-border-quiet'
    when :secondary
      'text-wa-brand-fill-loud bg-transparent border-wa-brand-border-loud' +
        ' hover:bg-wa-brand-fill-quiet active:bg-wa-brand-fill-normal' +
        ' active:text-wa-brand-on-loud'
    when :cancel
      'text-wa-warning-fill-loud bg-transparent border-wa-warning-border-loud' +
        ' hover:bg-wa-warning-fill-normal hover:text-wa-warning-on-normal' +
        ' active:bg-wa-warning-fill-quiet active:text-wa-warning-on-quiet'
    when :destroy
      'text-wa-danger-fill-quiet bg-transparent border-wa-danger-border-loud' +
        ' hover:bg-wa-danger-fill-normal hover:text-wa-danger-on-normal' +
        ' active:bg-wa-danger-fill-quiet active:text-wa-danger-on-quiet'
    else
      raise ArgumentError, "unexpected button type #{@type}: expected #{SupportedTypes}"
    end
  end
end
