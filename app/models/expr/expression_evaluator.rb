# frozen_string_literal: true

class Expr::ExpressionEvaluator
  def evaluate(expr, values = {})
    return expr if expr.class.in? ValueListTypes

    if expr.is_a? Array
      symbol = symbol_interpret(expr.first)
      cmd = CommandMap[symbol.to_sym]
      raise ArgumentError, "call-expression does not start with callable (key does not specify correct command)" if cmd.nil?

      cmd.new.evaluate(expr.drop(1), evaluator: self)
    elsif expr.is_a? Hash
      symbol = symbol_interpret(expr)
      val = values[symbol]
      raise ArgumentError, "call-expression does not start with callable (symbol but undefined)" if val.nil?

      val
    else
      raise ArgumentError, "call-expression is not callable (neither array not variable)"
    end
  end

  private

  ValueListTypes = [String, Integer, Float].freeze
  CommandMap = {
    :+ => Expr::SumCommand,
    :- => Expr::MinusCommand,
    :* => Expr::MultiplyCommand,
    :/ => Expr::DivideCommand,
    :int => Expr::IntCommand,
    :ceil => Expr::CeilCommand,
  }.freeze

  def symbol_interpret(sym)
    raise ArgumentError, "call-expression does not start with callable (not hash)" unless sym.is_a? Hash
    raise ArgumentError, "call-expression does not start with callable (does not have s key)" unless sym.key? "s"
    sym["s"]
  end

  def evaluatable(sym) = ValueListTypes.include? sym.class
end
