# frozen_string_literal: true

class Expr::CeilCommand < Expr::UnaryCommand
  def initialize
    super("ceil")
  end

  protected

  def unary_calculate(arg) = arg.ceil
end
