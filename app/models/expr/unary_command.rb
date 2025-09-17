# frozen_string_literal: true

class Expr::UnaryCommand < Expr::Command
  def initialize(name)
    @name = name
  end

  protected

  def calculate(args)
    raise ArgumentError, "#{@name} only takes one argument (given #{args.length})" unless args.length == 1
    unary_calculate(args.first)
  end

  def unary_calculate(arg)
    raise NotImplementedError, "implement in subclass"
  end
end
