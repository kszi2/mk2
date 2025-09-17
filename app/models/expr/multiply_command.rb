# frozen_string_literal: true

class Expr::MultiplyCommand < Expr::Command
  protected

  def calculate(args) = args.inject(:*)
end
