module MarkedPointsHelper
  def prog1_point_marker(mp)
    if mp.rating_point.criterion?
      return "(+)" if mp.marked_for == 0
      "(-)"
    else
      return "[+]" if mp.marked_for > 0
      "[-]"
    end
  end

  def prog2_point_achievable(mp)
    return "GO-NOGO" if mp.rating_point.criterion?
    mp.rating_point.available_points
  end

  def prog2_point_achieved(mp)
    if mp.rating_point.criterion?
      return "GO" if mp.marked_for == 0
      "NOGO"
    else
      mp.marked_for
    end
  end
end
