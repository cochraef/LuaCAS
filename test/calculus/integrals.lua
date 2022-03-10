local a = dparse("int(x^2, x)")
local b = dparse("int(x^-1, x, 1, e)")
local c = dparse("int(3*x^2+2*x+6, x)")
local d = dparse("int(sin(x)*cos(x), x)")
local e = dparse("int(2*x*cos(x^2), x)")
local f = dparse("int(sin(2*x), x)")
local g = dparse("int(e^sin(x), x)")
local h = dparse("int((1 / (1 + (1 / x))), x)")
local i = dparse("int(e^(x^(1/2)), x)")
local j = dparse("int((x^3+1)/(x-2), x)")
local k = dparse("int((x^2-x+1)/(x^3+3*x^2+3*x+1), x)")
local l = dparse("int(1 / (x^3+6*x), x)")

starttest("integration")
test(a, "int((x ^ 2), x)")
test(a:autosimplify(), "(1/3 * (x ^ 3))", a)
test(b:autosimplify(), "1", b)
test(c:autosimplify(), "((6 * x) + (x ^ 2) + (x ^ 3))", c)
test(d:autosimplify(), "(-1/2 * (cos(x) ^ 2))", d)
test(e:autosimplify(), "sin((x ^ 2))", e)
test(f:autosimplify(), "(-1/2 * cos((2 * x)))", f)
test(g:autosimplify(), "int((e ^ sin(x)), x)", g)
test(h:autosimplify(), "int((1 / (1 + (1 / x))), x)", h)
test(i:autosimplify(), "int((e ^ (x ^ 1/2)), x)", i)
test(j:autosimplify(), "((4 * x) + (9 * log(e, (-2 + x))) + (x ^ 2) + (1/3 * (x ^ 3)))", j)
test(k:autosimplify(), "(log(e, (1 + x)) + (-3/2 * ((1 + x) ^ -2)) + (3 * ((1 + x) ^ -1)))", k)
-- test(l:autosimplify(), "((1/6 * log(e, x)) + (-1/12 * log(e, (6 + (x ^ 2)))))", l)

endtest()