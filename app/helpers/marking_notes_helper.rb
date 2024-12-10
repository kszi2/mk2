module MarkingNotesHelper
  def note_preface(note)
    if note.fixed
      "(Javítva)"
    elsif note.points_cost == 0
      "(Megjegyzés)"
    elsif note.marked_point.rating_point.criterion? # LoD breakage
      "(Megtagadva)"
    else
      case note.points_cost
      when Float
        sprintf "(%+.1fp)", -note.points_cost
      else
        sprintf "(%+dp)", -note.points_cost
      end
    end
  end

  def note_reasoning(note)
    return "¯\\_(ツ)_/¯" if note.reason.empty?
    note.reason.gsub("\r", "").gsub("\n", "\n    ")
  end
end
