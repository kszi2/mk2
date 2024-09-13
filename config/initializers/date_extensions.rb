class Date
  def first_semester?
    self.month < 7 && self.month > 2
  end

  def semester_number
    return 1 if first_semester?
    2
  end

  def semester_range
    if first_semester?
      Date.first_semester_range(self.year)
    else
      Date.second_semester_range(self.year)
    end
  end

  def Date.first_semester_range(curr_year = Date.today.year)
    Date.new(curr_year, 9, 1)..Date.new(curr_year + 1, 1, 31)
  end

  def Date.second_semester_range(curr_year = Date.today.year)
    Date.new(curr_year, 2, 1)..Date.new(curr_year + 1, 6, 30)
  end
end
