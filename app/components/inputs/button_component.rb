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
      'text-text-normal bg-surface-raised border-surface-border' +
        ' hover:bg-surface-default active:bg-surface-lowered'
    when :primary
      'text-brand-on-loud bg-brand-fill-loud border-brand-border-loud' +
        ' hover:bg-brand-fill-normal active:bg-brand-fill-quiet' +
        ' hover:border-brand-border-normal active:border-brand-border-quiet'
    when :secondary
      'text-brand-fill-loud bg-transparent border-brand-border-loud' +
        ' hover:bg-brand-fill-quiet active:bg-brand-fill-normal' +
        ' active:text-brand-on-loud'
    when :cancel
      'text-warning-fill-loud bg-transparent border-warning-border-loud' +
        ' hover:bg-warning-fill-normal hover:text-warning-on-normal' +
        ' active:bg-warning-fill-quiet active:text-warning-on-quiet'
    when :destroy
      'text-danger-fill-quiet bg-transparent border-danger-border-loud' +
        ' hover:bg-danger-fill-normal hover:text-danger-on-normal' +
        ' active:bg-danger-fill-quiet active:text-danger-on-quiet'
    else
      raise ArgumentError, "unexpected button type #{@type}: expected #{SupportedTypes}"
    end
  end
end
