# frozen_string_literal: true

class Expr::DivideCommand < Expr::Command
  protected

  def calculate(args) = args.map(&:to_f).inject(:/)
end
