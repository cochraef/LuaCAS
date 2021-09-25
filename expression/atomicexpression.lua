-- Interface for an 'atomic' mathematical expression, i.e., an element of a set
-- AtomicExpressions have the following relation to other classes:
--      AtomicExpresssions extend Expressions
AtomicExpression = {}
__AtomicExpression = {}

----------------------
-- Instance methods --
----------------------

-- Evaluates the current expression to itself
function AtomicExpression:evaluate()
    return self
end

-- Default substitution behavior, obviously can be overwritten for atomic expressions with symbols
function AtomicExpression:substitute(variables)
    return self
end

-- Atomic expressions are atomic, suprisingly
function AtomicExpression:isAtomic()
    return true
end

-- Most atomic expressions can be evaluated
function AtomicExpression:isEvaluatable()
    return true
end

-----------------
-- Inheritance --
-----------------

__AtomicExpression.__index = Expression
AtomicExpression = setmetatable(AtomicExpression, __AtomicExpression)