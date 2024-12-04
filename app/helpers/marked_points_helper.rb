# frozen_string_literal: true

module MarkedPointsHelper
  def point_achievable(mp)
    return "GO-NOGO" if mp.rating_point.criterion?
    mp.rating_point.available_points
  end
  alias prog2_point_achievable point_achievable

  def point_achieved(mp, go: 'GO', nogo: 'NOGO')
    if mp.rating_point.criterion?
      go_nogo_value(mp, go: go, nogo: nogo, wrap: "")
    else
      mp.marked_for
    end
  end
  alias prog2_point_achieved point_achieved

  def go_nogo_value(mp, go: 'GO', nogo: 'NOGO', wrap: "()")
    raise ArgumentError.new("go_nogo_value: invalid wrap parameter: #{wrap} (must be at 0..2 long)") \
      unless wrap.length.in?(0..2)
    pre = wrap[0] || ""
    post = wrap[1] || pre

    if mp.marked_for == mp.available_points
      pre + go + post
    else
      pre + nogo + post
    end
  end
end
