# frozen_string_literal: true

class Expr::MinusCommand < Expr::Command
  protected

  def calculate(args) = args.inject(:-)
end
