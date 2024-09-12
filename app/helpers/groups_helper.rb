module GroupsHelper
  def render_next_date(next_date)
    return "Never" if next_date.nil?
    return "Today" if next_date == Date.today
    next_date.strftime("%F")
  end
end
