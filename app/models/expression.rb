class Expression < ApplicationRecord
  validates :sexpr, presence: true, length: { minimum: 1, maximum: 1024 }
  validates :parsed, presence: true

  def evaluate(values = {}) = Expr::ExpressionEvaluator.new.evaluate(parsed, values)

  before_validation :parse

  def parse
    if sexpr_changed?
      read_sexpr sexpr
    elsif parsed.present?
      parsed
    else
      read_sexpr sexpr
    end
  end

  private

  def read_sexpr(sexpr)
    expr = SXP.read sexpr
    self.parsed = convert_symbol expr
  end

  def convert_symbol(val)
    return { s: val } if val.is_a? Symbol
    return val.map { |x| convert_symbol x } if val.is_a? Array
    val
  end
end
