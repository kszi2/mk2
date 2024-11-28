# frozen_string_literal: true

class NotePrefaceComponent < ViewComponent::Base
  def initialize(text:, fixed:, points_cost:, fatal:, active: true)
    @text = text
    @fixed = fixed
    @points_cost = points_cost
    @fatal = fatal
    @active = active
  end

  def preface_symbol
    sym = preface_symbol_name
    return "" if sym.blank?
    tag.i class: "fa-solid #{sym}"
  end

  def chevron_color
    return "text-wa-text-quiet" unless @active
    ""
  end

  def preface_text
    return "" if @fixed
    return "" if only_note?
    return "" if @fatal
    tag.i class: "fa-solid" do
      if @points_cost.is_a?(Float)
        sprintf "%+.1f", -@points_cost
      else
        sprintf "%+d", -@points_cost
      end
    end
  end

  def data_start
    return "¯\\_(ツ)_/¯" if @text.blank?
    @text
  end

  private

  def data_classes
    return "text-wa-text-quiet" if @fixed
    ""
  end

  def only_note?
    @points_cost == 0
  end

  def preface_symbol_name
    if @fixed
      return "fa-comment-slash text-wa-success-fill-loud" if only_note?
      return "fa-bug-slash text-wa-success-fill-loud"
    end
    return "fa-comment" if only_note?
    return "fa-xmark-large text-wa-danger-fill-loud" if @fatal
    ""
  end
end
