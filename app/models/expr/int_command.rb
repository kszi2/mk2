# frozen_string_literal: true

class Expr::IntCommand < Expr::UnaryCommand
  def initialize
    super "int"
  end

  protected

  def unary_calculate(arg) = arg.to_i
end
