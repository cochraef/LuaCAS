--- @class FunctionExpression
--- Represents a generic function that takes zero or more expressions as inputs.
--- @field name SymbolExpression
--- @field expressions table<number, Expression>
--- @alias Function FunctionExpression
FunctionExpression = {}
__FunctionExpression = {}

----------------------------
-- Instance functionality --
----------------------------

--- Creates a new function expression with the given operation.
--- @param name string|SymbolExpression
--- @param expressions table<number, Expression>
--- @param orders table<number, Integer>
--- @return FunctionExpression
function FunctionExpression:new(name, expressions, orders)
    local o = {}
    local __o = Copy(__ExpressionOperations)

    if type(name) == "table" and name:type() == SymbolExpression then
        name = name.symbol
    end

    if TrigExpression.NAMES[name] and #expressions == 1 then
        return TrigExpression(name, expressions[1])
    end

    -- TODO: Symbol Checking For Constructing derivatives like this
    if string.sub(name, #name, #name) == "'" and #expressions == 1 then
       return DerivativeExpression(FunctionExpression(string.sub(name, 1, #name - 1), expressions), SymbolExpression("x"), true)
    end

    o.name = name
    o.expressions = expressions
    if orders then 
        o.orders = orders
    else
        o.orders = Copy(expressions)
        for index,_ in ipairs(o.orders) do 
            o.orders[index] = Integer.zero()
        end
    end

    __o.__index = FunctionExpression
    __o.__tostring = function(a)
        local total = Integer.zero()
        for _,integer in ipairs(a.orders) do 
            total = total + integer
        end
        if total == Integer.zero() then
            local expressionnames = a.name .. '('
            for index, expression in ipairs(a.expressions) do
                expressionnames = expressionnames .. tostring(expression)
                if a.expressions[index + 1] then
                    expressionnames = expressionnames .. ', '
                end
            end
            return expressionnames .. ')'
        else
            local expressionnames = 'd^' .. tostring(total) .. a.name .. '/'
            for index,order in ipairs(a.orders) do 
                if order > Integer.zero() then 
                    expressionnames = expressionnames .. 'd' .. tostring(a.expressions[index])
                    if order > Integer.one() then 
                        expressionnames = expressionnames .. '^' .. tostring(order)
                    end
                end
            end
            expressionnames = expressionnames .. '('
            for index, expression in ipairs(a.expressions) do
                expressionnames = expressionnames .. tostring(expression)
                if a.expressions[index + 1] then
                    expressionnames = expressionnames .. ', '
                end
            end
            return expressionnames .. ')'
        end
    end
    __o.__eq = function(a, b)
        -- if b:type() == TrigExpression then
        --     return a == b:tofunction()
        -- end
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

--- @return FunctionExpression
function FunctionExpression:evaluate()
    local results = {}
    for index, expression in ipairs(self:subexpressions()) do
        results[index] = expression:evaluate()
    end
    return FunctionExpression(self.name, results)
end

--- @return FunctionExpression
function FunctionExpression:autosimplify()
    -- Since the function is completely generic, we can't really do anything execpt autosimplify subexpressions.
    local results = {}
    for index, expression in ipairs(self:subexpressions()) do
        results[index] = expression:autosimplify()
    end
    return FunctionExpression(self.name, results, self.orders)
end

--- @return table<number, Expression>
function FunctionExpression:subexpressions()
    return self.expressions
end

--- @param subexpressions table<number, Expression>
--- @return FunctionExpression
function FunctionExpression:setsubexpressions(subexpressions)
    return FunctionExpression(self.name, subexpressions)
end

--- @param other Expression
--- @return boolean
function FunctionExpression:order(other)
    if other:isatomic() then
        return false
    end

    -- CASC Autosimplfication has some symbols appearing before functions, but that looks bad to me, so all symbols appear before products now.
    -- if other:type() == SymbolExpression then
    --     return SymbolExpression(self.name):order(other)
    -- end

    if other:type() == BinaryOperation then
        if other.operation == BinaryOperation.ADD or other.operation == BinaryOperation.MUL then
            return BinaryOperation(other.operation, {self}):order(other)
        end

        if other.operation == BinaryOperation.POW then
            return (self^Integer.one()):order(other)
        end
    end

    if other:type() ~= FunctionExpression and other:type() ~= TrigExpression then
        return true
    end

    if other:type() == SqrtExpression then
        return false
    end

    if self.name ~= other.name then
        return SymbolExpression(self.name):order(SymbolExpression(other.name))
    end

    local k = 1
    while self:subexpressions()[k] and other:subexpressions()[k] do
        if self:subexpressions()[k] ~= other:subexpressions()[k] then
            return self:subexpressions()[k]:order(other:subexpressions()[k])
        end
        k = k + 1
    end
    return #self.expressions < #other.expressions
end

--- @return string
function FunctionExpression:tolatex()
    local out = tostring(self.name)
    if self:type() == TrigExpression then
        out = "\\" .. out
    end
    if self:type() ~= TrigExpression and string.len(self.name)>1 then
        --if out:sub(2,2) ~= "'" then
            --local fp = out:find("'")
            --if fp then
            --    out = '\\operatorname{' .. out:sub(1,fp-1) .. '}' .. out:sub(fp,-1)
            --else
        out = '\\operatorname{' .. out .. '}'
            --end
        --end
    end
    if #self.expressions == 1 then 
        local order = self.orders[1]
        if order == Integer.zero() then
            goto continue
        else
            if order < Integer(5) then 
                while order > Integer.zero() do
                    out = out .. "'"
                    order = order - Integer.one()
                end
            else
                out = out .. '^{(' .. order:tolatex() .. ')}'
            end
        end
    end
    if #self.expressions > 1 then 
        local order = Integer.zero()
        for _,integer in ipairs(f.orders) do 
            order = order + integer
        end
        if order == Integer.zero() then 
            goto continue
        else
            if order < Integer(4) then 
                out = out .. '_{'
                for index,integer in ipairs(f.orders) do 
                    local i = integer:asnumber()
                    while i > 0 do 
                        out = out .. self.expressions[index]:tolatex()
                        i = i - 1
                    end
                end 
                out = out .. '}'
            else
                out = '\\frac{\\partial^{' .. order:tolatex() .. '}' .. out .. '}{'
                for index, integer in ipairs(f.orders) do 
                    if integer > Integer.zero() then 
                        out = out .. '\\partial ' .. self.expressions[index]:tolatex()
                        if integer ~= Integer.one() then 
                            out = out .. '^{' .. integer:tolatex() .. '}'
                        end
                    end
                end
                out = out .. '}'
            end
        end
    end
    ::continue::
    out = out .. '\\left('
    for index, expression in ipairs(self:subexpressions()) do
        out = out .. expression:tolatex()
        if self:subexpressions()[index + 1] then
            out = out .. ', '
        end
    end
    return out .. '\\right)'
end

-----------------
-- Inheritance --
-----------------

__FunctionExpression.__index = CompoundExpression
__FunctionExpression.__call = FunctionExpression.new
FunctionExpression = setmetatable(FunctionExpression, __FunctionExpression)