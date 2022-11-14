class PolishNotation

  def isOperator(str)
    return !str.match?(/[[:digit:]]/)
  end

  def getPriority(str)
    return 1 if (str == "+" || str == "-")

    return 2 if (str == "*" || str == "/")

    return 3 if str == "^"

    return 4 if (str == "cos" || str == "sin" || str == "tan" || str == "cot")

    return 0
  end

  def isTrigonimetric(str)
    return str == "c" || str == "o" || str == "s" || str == "i" || str == "n" ||
      str == "t" || str == "a"
  end

  def infix_to_prefix(str)
    operators = []
    operands = []
    need_to_merge = false
    trigonometric = ""

    for i in str.split(//).reject {|x| x == " "}
      case
      when i == "("
        operators << trigonometric + " " if !trigonometric.empty?
        operators << i

        trigonometric = ""
        need_to_merge = false
      when i == ")"
        while operators.length != 0 && operators.last != "(" do
          operand1 = operands.pop
          operand2 = operands.pop
          operator = operators.pop

          operands.push(operator + operand2 + operand1)
        end

        operators.pop
        need_to_merge = false
      when !isOperator(i)
        operands << operands.pop.strip + i + " " if need_to_merge

        operands << i + " " if !need_to_merge

        need_to_merge = true
      else
        if isTrigonimetric(i)
          trigonometric << i
          next
        end

        while operators.length != 0 && getPriority(i.to_s) <= getPriority(operators.last&.strip) do
          operand1 = operands.pop
          operand2 = operands.pop
          operator = operators.pop

          operands.push(operator + operand2 + operand1)
        end

        operators.push(i + " ")
        need_to_merge = false
      end
    end

    while operators.length != 0 do
      operand1 = operands.pop
      operand2 = operands.pop
      operator = operators.pop

      tmp = ""
      tmp << operator if !operator.nil?
      tmp << operand2 if !operand2.nil?
      tmp << operand1 if !operand1.nil?
      operands.push(tmp)
    end

    return operands.last
  end

  def isDigit(str)
    return str.match?(/[[:digit:]]/)
  end

  def evaluatePrefix(str)
    stack = []

    for i in str.split(" ").reverse
      if isDigit(i)
        stack.push(i.to_f)
      else
        operand1 = 0
        operand2 = 0

        if str == "cos" || str == "sin" || str == "tan" || str == "cot"
          operand1 = stack.pop.to_f
        else
          operand1 = stack.pop.to_f
          operand2 = stack.pop.to_f
        end

        case i
        when "+"
          stack.push(operand1 + operand2)
        when "-"
          stack.push(operand1 - operand2)
        when "*"
          stack.push(operand1 * operand2)
        when "/"
          stack.push(operand1 / operand2)
        when "^"
          stack.push(operand1**operand2)
        when "cos"
          stack.push(Math.cos(operand1))
        when "sin"
          stack.push(Math.sin(operand1))
        when "tan"
          stack.push(Math.tan(operand1))
        when "cot"
          stack.push(1/Math.tan(operand1))
        end
      end
    end

    return stack.pop;
  end
end


puts "Enter string: "
user_input = gets.chomp.to_s

convert = PolishNotation.new()
res = convert.infix_to_prefix(user_input)
puts "\nPrefix notation: " + res
calc_res = convert.evaluatePrefix(res)
puts "\nResult = " + calc_res.to_s