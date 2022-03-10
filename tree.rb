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
    return value if !operator.kind_of?(Operator)
    operator.result(left.result, right.result)
  end

  def to_s
    return value.to_s if !operator.kind_of?(Operator)
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
