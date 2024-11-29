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
    return "text-wa-text-quiet animate-text-quietize" if @fixed
    "text-wa-text-normal animate-text-normalize"
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
