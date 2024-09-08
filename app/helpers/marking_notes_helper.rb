module MarkingNotesHelper
  def note_preface(note)
    if note.points_cost == 0
      "(Megjegyzés)"
    elsif note.marked_point.rating_point.criterion? # LoD breakage
      "(Megtagadva)"
    else
      "(-#{note.points_cost}p)"
    end
  end

  def note_reasoning(note)
    return "Szar" if note.reason.empty?
    note.reason
  end
end
