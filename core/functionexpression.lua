-- Represents an unspecified function from a tuple of expressions to an expression.
-- FunctionExpressions have the following instance variables:
--      name - the string name of the function
--      expressions - a list of expressions that are passed in to the function
-- FunctionExpressions have the following relations to other classes:
--      FunctionExpressions extend CompoundExpressions
FunctionExpression = {}
__FunctionExpression = {}

----------------------------
-- Instance functionality --
----------------------------

-- Creates a new function expression with the given operation
function FunctionExpression:new(name, expressions, trigbypass)
    local o = {}
    local __o = Copy(__ExpressionOperations)

    if type(name) == "table" and name:type() == SymbolExpression then
        name = name.symbol
    end

    if TrigExpression.NAMES[name] and #expressions == 1 and (not trigbypass) then
        return TrigExpression(name, expressions[1])
    end

    o.name = name
    o.expressions = expressions

    __o.__index = FunctionExpression
    __o.__tostring = function(a)
        local expressionnames = a.name .. '(';
        for index, expression in ipairs(a.expressions) do
            expressionnames = expressionnames .. tostring(expression)
            if a.expressions[index + 1] then
                expressionnames = expressionnames .. ', '
            end
        end
        return expressionnames .. ')'
    end
    __o.__eq = function(a, b)
        if b:type() == TrigExpression then
            return a == b:tofunction()
        end
        if b:type() ~= FunctionExpression then
            return false
        end
        if #a.expressions ~= #b.expressions then
            return false
        end
        for index, _ in ipairs(a.expressions) do
            if a.expressions[index] ~= b.expressions[index] then
                return false
            end
        end
        return a.name == b.name
    end

    o = setmetatable(o, __o)

    return o
end

function FunctionExpression:evaluate()
    return self
end

function FunctionExpression:substitute(map)
    for expression, replacement in pairs(map) do
        if self == expression then
            return replacement
        end
    end
    local results = {}
    for index, expression in ipairs(self.expressions) do
        results[index] = expression:substitute(map)
    end
    return FunctionExpression(self.name, results)
end

function FunctionExpression:autosimplify()
    local results = {}
    for index, expression in ipairs(self.expressions) do
        results[index] = expression:autosimplify()
    end
    return FunctionExpression(self.name, results)
end

function FunctionExpression:order(other)
    if other:isconstant() then
        return false
    end

    if other:type() == SymbolExpression then
        return SymbolExpression(self.name):order(other)
    end

    if other:type() == BinaryOperation then
        if other.operation == BinaryOperation.ADD or other.operation == BinaryOperation.MUL then
            return BinaryOperation(other.operation, {self}):order(other)
        end

        if other.operation == BinaryOperation.POW then
            return (self^Integer.one()):order(other)
        end
    end

    if other:type() == TrigExpression then
        return self:order(other:tofunction())
    end

    if other:type() ~= FunctionExpression then
        return true
    end

    if self.name ~= other.name then
        return SymbolExpression(self.name):order(SymbolExpression(other.name))
    end

    local k = 1
    while self.expressions[k] and other.expressions[k] do
        if self.expressions[k] ~= other.expressions[k] then
            return self.expressions[k]:order(other.expressions[k])
        end
        k = k + 1
    end
    return #self.expressions < #other.expressions
end

function FunctionExpression:tolatex()
    local out = self.name .. '(';
    for index, expression in ipairs(self.expressions) do
        out = out .. expression:tolatex()
        if self.expressions[index + 1] then
            out = out .. ', '
        end
    end
    return out .. ')'
end

-----------------
-- Inheritance --
-----------------

__FunctionExpression.__index = CompoundExpression
__FunctionExpression.__call = FunctionExpression.new
FunctionExpression = setmetatable(FunctionExpression, __FunctionExpression)