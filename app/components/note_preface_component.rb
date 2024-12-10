# frozen_string_literal: true

class NotePrefaceComponent < ViewComponent::Base
  def self.for(note)
    NotePrefaceComponent.new(id: note.id,
                             text: note.reason,
                             fixed: note.fixed,
                             points_cost: note.points_cost,
                             fatal: note.criterion?)
  end

  def initialize(id:, text:, fixed:, points_cost:, fatal:, active: true)
    @id = id
    @text = text
    @fixed = fixed
    @points_cost = points_cost
    @fatal = fatal
    @active = active
  end

  def head_id
    "note_preface_#{@id}"
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
    return "" if note_is_new?
    return "" if @fixed
    return "" if note_is_message?
    return "" if @fatal
    tag.i class: "fa-solid" do
      return "" if @points_cost.nil?
      if (@points_cost % 1).zero?
        sprintf "%+d", -@points_cost
      else
        sprintf "%+.1f", -@points_cost
      end
    end
  end

  def data_start
    return "¯\\_(ツ)_/¯" if @text.blank?
    @text
  end

  private

  def data_classes
    return "text-wa-text-quiet animate-text-quietize" if @fixed
    "text-wa-text-normal animate-text-normalize"
  end

  def preface_symbol_name
    return "fa-question" if note_is_new?
    if @fixed
      return "fa-comment-slash text-wa-success-fill-loud" if note_is_message?
      return "fa-bug-slash text-wa-success-fill-loud"
    end
    return "fa-comment" if note_is_message?
    return "fa-xmark-large text-wa-danger-fill-loud" if @fatal
    ""
  end

  def note_is_message?
    @points_cost.zero?
  end

  def note_is_new?
    @id.blank? || @id == 0
  end
end
