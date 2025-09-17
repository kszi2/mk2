require "test_helper"

class ExpressionTest < ActiveSupport::TestCase
  test "empty sexpr is invalid" do
    expr = Expression.new(sexpr: "")
    assert_raises SXP::Reader::EOF do
      refute expr.valid?
    end
  end

  test "long sexpr is invalid" do
    expr = Expression.new(sexpr: "1" * 1025)
    refute expr.valid?
    assert_includes expr.errors[:sexpr], "is too long (maximum is 1024 characters)"
  end

  test "single integer parses into a single int value" do
    expr = Expression.new(sexpr: "1")
    assert_equal 1, expr.parse
  end

  test "single string parses into a single string value" do
    expr = Expression.new(sexpr: "'1'")
    assert_equal "1", expr.parse
  end

  test "single string (double quote) parses into a single string value" do
    expr = Expression.new(sexpr: '"1"')
    assert_equal "1", expr.parse
  end

  test "single symbol parses into a hash value" do
    expr = Expression.new(sexpr: '+')
    assert_equal ({ s: :+ }), expr.parse
  end

  test "function call parses into an array value" do
    expr = Expression.new(sexpr: '(+ 1 2)')
    assert_equal [{ s: :+ }, 1, 2], expr.parse
  end

  test "nested function call parses into an nested array value" do
    expr = Expression.new(sexpr: '(+ 1 (- 2 2))')
    assert_equal [{ s: :+ }, 1, [{ s: :- }, 2, 2]], expr.parse
  end

  test "expression is not parsed multiple times" do
    expr = Expression.new(sexpr: "1")
    expr.parse
    expr.save!
    SXP.stubs(:read).raises(ArgumentError, "expression parser called twice")
    assert_equal 1, expr.parse
  end

  test "nested expression evaluates correctly" do
    expr = Expression.new(sexpr: "(int (* 39 (/ 32 40)))")
    expr.parse
    assert_equal 31, expr.evaluate
  end
end
