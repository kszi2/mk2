# frozen_string_literal: true

class Expr::Command
  def evaluate(args, evaluator:)
    raise ArgumentError, "evaluator must be specified" unless evaluator.present?
    calculate args.map { |arg| evaluator.evaluate(arg) }
  end

  protected

  def calculate(args) = raise NotImplementedError, "implement in subclass"
end
