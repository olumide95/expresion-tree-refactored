class Operator
end  

class AdditionOperator < Operator
  def result(left, right)
    left + right
  end

  def to_s(left, right)
    "(#{left} + #{right})"
  end
end

class SubtractionOperator < Operator
  def result(left, right)
    left - right
  end

  def to_s(left, right)
    "(#{left} - #{right})"
  end
end

class MultiplicationOperator < Operator
  def result(left, right)
    left * right
  end

  def to_s(left, right)
    "(#{left} x #{right})"
  end
end

class DivisionOperator < Operator
  def result(left, right)
    left / right
  end

  def to_s(left, right)
    "(#{left} ÷ #{right})"
  end
end


class Node
  def initialize(operator, value, left, right)
    @operator = operator
    @value = value
    @left = left
    @right = right
  end
  
  attr_reader :operator, :value, :left, :right
  
  def result
    return value unless operator.is_a?(Operator)
    operator.result(left.result, right.result)
    rescue NoMethodError, TypeError, ZeroDivisionError
     nil
  end

  def to_s
    return value.to_s unless operator.is_a?(Operator)
    operator.to_s(left.to_s, right.to_s)
  end
end

tree = Node.new(
  DivisionOperator.new,
  nil,
  Node.new(
    AdditionOperator.new,
    nil,
    Node.new("", 7, nil, nil),
    Node.new(
      MultiplicationOperator.new,
      nil,
      Node.new(SubtractionOperator.new, nil,
        Node.new("", 3, nil, nil),
        Node.new("", 2, nil, nil)
      ),
      Node.new("", 5, nil, nil)
    )
  ),
  Node.new("", 6, nil, nil)
);

def assert_equal(expected, actual)
  if expected != actual
    puts "Expected: #{expected.inspect}, got: #{actual.inspect}"
    exit 1
  end
end

assert_equal "((7 + ((3 - 2) x 5)) ÷ 6)", tree.to_s
assert_equal 2, tree.result

# Test it returns nil when a left operand is nil
tree = Node.new(
  DivisionOperator.new,
  nil,
  Node.new(
    AdditionOperator.new,
    nil,
    nil,
    Node.new(
      MultiplicationOperator.new,
      nil,
      Node.new(SubtractionOperator.new, nil,
        Node.new("", 3, nil, nil),
        Node.new("", 2, nil, nil)
      ),
      Node.new("", 5, nil, nil)
    )
  ),
  Node.new("", 6, nil, nil)
);

assert_equal "(( + ((3 - 2) x 5)) ÷ 6)", tree.to_s
assert_equal nil, tree.result

# Test it returns nil when a right operand is nil
tree = Node.new(
  DivisionOperator.new,
  nil,
  Node.new(
    AdditionOperator.new,
    nil,
    Node.new("", 7, nil, nil),
    Node.new(
      MultiplicationOperator.new,
      nil,
      Node.new(SubtractionOperator.new, nil,
        Node.new("", 2, nil, nil),
        nil,
      ),
      Node.new("", 5, nil, nil)
    )
  ),
  Node.new("", 6, nil, nil)
);

assert_equal "((7 + ((2 - ) x 5)) ÷ 6)", tree.to_s
assert_equal nil, tree.result

# Test Division by zero returns nil
tree = Node.new(DivisionOperator.new, nil,
        Node.new("", 2, nil, nil),
        Node.new("", 0, nil, nil)
      )

assert_equal "(2 ÷ 0)", tree.to_s
assert_equal nil, tree.result

# Test to_s for all Operators returns expected string
assert_equal "(a + b)", AdditionOperator.new.to_s('a', 'b')
assert_equal "(a - b)", SubtractionOperator.new.to_s('a', 'b')
assert_equal "(a x b)", MultiplicationOperator.new.to_s('a', 'b')
assert_equal "(a ÷ b)", DivisionOperator.new.to_s('a', 'b')
