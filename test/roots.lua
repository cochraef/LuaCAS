require("algebra._init")
require("_lib.pepperfish")


local function test(actual, expected, initial)
    if initial then
        if tostring(expected) == tostring(actual) then
            print(tostring(initial) .. " -> " .. tostring(actual))
        else
            print(tostring(initial) .. " -> " .. tostring(actual) .. " (Expected: " .. tostring(expected) .. ")")
        end
    else
        if tostring(expected) == tostring(actual) then
            print("Result: " .. tostring(actual))
        else
            print("Result: ".. tostring(actual) .. " (Expected: " .. tostring(expected) .. ")")
        end
    end
end

local a = PolynomialRing({Integer(1), Integer(2), Integer(3), Integer(4), Integer(5)}, "x")
local b = PolynomialRing({Integer(1) / Integer(3), Integer(1) / Integer(12), Integer(6) / Integer(3)}, "x")
local c = PolynomialRing({Integer(12), Integer(4)}, "x")
local d = PolynomialRing({Integer(21), Integer(10), Integer(1)}, "x")
local e = PolynomialRing({Integer(-6), Integer(1), Integer(1)}, "x")
local f = PolynomialRing({Integer(-1), Integer(-2), Integer(15), Integer(36)}, "x")
local g = PolynomialRing({Integer(1), Integer(7), Integer(15), Integer(9)}, "x")
local h = PolynomialRing({Integer(2), Integer(3), Integer(1)}, "x")
local i = PolynomialRing({Integer(8), Integer(20), Integer(18), Integer(7), Integer(1)}, "x")
local j = PolynomialRing({Integer(108), Integer(324), Integer(387), Integer(238), Integer(80), Integer(14), Integer(1)}, "x")
local k = PolynomialRing({Integer(30), Integer(11), Integer(1)}, "x")
local l = PolynomialRing({Integer(6), Integer(11), Integer(6), Integer(1)}, "z")
local m = PolynomialRing({Integer(1), Integer(10), Integer(45), Integer(120), Integer(210), Integer(252), Integer(210), Integer(120), Integer(45), Integer(10), Integer(1)}, "x")
local n = PolynomialRing({Integer(24), Integer(50), Integer(35), Integer(10), Integer(1), Integer(0), Integer(24), Integer(50), Integer(35), Integer(10), Integer(1)}, "x")
local o = PolynomialRing({Integer(24), Integer(50), Integer(59), Integer(60), Integer(36), Integer(10), Integer(1)}, "x")
local p = PolynomialRing({Integer(-110592), Integer(59904), Integer(-5760), Integer(720), Integer(-48), Integer(1)}, "x")
local q = PolynomialRing({Integer(3), Integer(-9), Integer(27), Integer(-36), Integer(36)}, "z")
local r = PolynomialRing({Integer(0), Integer(0), Integer(0), Integer(0), Integer(0), Integer(0), Integer(4)}, "x");
local s = PolynomialRing({Integer(1), Integer(0), Integer(-4), Integer(0), Integer(1)}, "x")
local t = PolynomialRing({Integer(1), Integer(-1), Integer(1), Integer(1)}, "t")

print("Testing polynomial-expression conversion...")
test(a:tocompoundexpression():autosimplify():topolynomial(), a)
test(b:tocompoundexpression():autosimplify():topolynomial(), b)
test(c:tocompoundexpression():autosimplify():topolynomial(), c)
print()

print("Testing polynomial root-finding...")
test(ToStringArray(a:roots()), "{Root Of: (5x^4+4x^3+3x^2+2x^1+1x^0)}", a)
test(ToStringArray(b:roots()), "{(1/48 * (-1 + ((383 ^ 1/2) * i))), (1/48 * (-1 + (-1 * (383 ^ 1/2) * i)))}", b)
test(ToStringArray(c:roots()), "{-3}", c)
test(ToStringArray(d:roots()), "{-3, -7}", d)
test(ToStringArray(e:roots()), "{2, -3}", e)
test(ToStringArray(f:roots()), "{1/4, -1/3}", f)
test(ToStringArray(g:roots()), "{-1, -1/3}", g)
test(ToStringArray(h:roots()), "{-1, -2}", h)
test(ToStringArray(i:roots()), "{-1, -2}", i)
test(ToStringArray(j:roots()), "{-1, -2, -3}", j)
test(ToStringArray(k:roots()), "{-5, -6}", k)
test(ToStringArray(l:roots()), "{-1, -2, -3}", l)
test(ToStringArray(m:roots()), "{-1}", m)
test(ToStringArray(n:roots()), "", n)
test(ToStringArray(o:roots()), "", o)
test(ToStringArray(p:roots()), "", p)
test(ToStringArray(q:roots()), "", q)
test(ToStringArray(r:roots()), "{0}", r)
test(ToStringArray(s:roots()), "", s)
test(ToStringArray(t:roots()), "", t)