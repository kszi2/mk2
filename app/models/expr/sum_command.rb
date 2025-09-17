# frozen_string_literal: true

class Expr::SumCommand < Expr::Command
  protected

  def calculate(args) = args.sum
end
