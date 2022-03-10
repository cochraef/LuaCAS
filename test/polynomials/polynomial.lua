
local a = PolynomialRing({
    Integer(1),
    Integer(2),
    Integer(3),
    Integer(4),
    Integer(5)
}, "x")

local b = PolynomialRing({
    Integer(1) / Integer(3),
    Integer(1) / Integer(12),
    Integer(6) / Integer(3),
}, "x")

local c = PolynomialRing({
    Integer(12),
    Integer(4)
}, "x")

local h = PolynomialRing({Integer(2), Integer(3), Integer(1)}, "x")
local i = PolynomialRing({Integer(8), Integer(20), Integer(18), Integer(7), Integer(1)}, "x")
local j = PolynomialRing({Integer(108), Integer(324), Integer(387), Integer(238), Integer(80), Integer(14), Integer(1)}, "x")
local k = PolynomialRing({Integer(30), Integer(11), Integer(1)}, "x")
local l = PolynomialRing({Integer(6), Integer(11), Integer(6), Integer(1)}, "z")
local m = PolynomialRing({Integer(1), Integer(10), Integer(45), Integer(120), Integer(210), Integer(252), Integer(210), Integer(120), Integer(45), Integer(10), Integer(1)}, "x")
local n = PolynomialRing({Integer(24), Integer(50), Integer(35), Integer(10), Integer(1), Integer(0), Integer(24), Integer(50), Integer(35), Integer(10), Integer(1)}, "x")
local o = PolynomialRing({Integer(24), Integer(50), Integer(59), Integer(60), Integer(36), Integer(10), Integer(1)}, "x")
local p = PolynomialRing({Integer(-110592), Integer(59904), Integer(-5760), Integer(720), Integer(-48), Integer(1)}, "x")

local d = PolynomialRing({Integer(21), Integer(10), Integer(1)}, "x")
local e = PolynomialRing({Integer(-6), Integer(1), Integer(1)}, "x")

local f = PolynomialRing({Integer(-1), Integer(-2), Integer(15), Integer(36)}, "x")
local g = PolynomialRing({Integer(1), Integer(7), Integer(15), Integer(9)}, "x")

local q = PolynomialRing({Integer(3), Integer(-9), Integer(27), Integer(-36), Integer(36)}, "z")
local r = PolynomialRing({Integer(0), Integer(0), Integer(0), Integer(0), Integer(0), Integer(0), Integer(4)}, "x");
local s = PolynomialRing({Integer(1), Integer(0), Integer(-4), Integer(0), Integer(1)}, "x")

local x = Integer(3)
local y = Integer(-1) / Integer(6)

local multia = PolynomialRing({Integer(4),
                    Integer(0),
                    PolynomialRing({Integer(0), Integer(0), Integer(-6)}, "y"),
                    PolynomialRing({Integer(1), Integer(3)}, "y")}, "x")
local multib = PolynomialRing({PolynomialRing({Integer(0), Integer(6)}, "y"),
                            Integer(0),
                            PolynomialRing({Integer(-4), Integer(12)}, "y")}, "x")

starttest("polynomial construction")
test(a, "5x^4+4x^3+3x^2+2x^1+1x^0")
test(a.degree, 4)
test(b, "2x^2+1/12x^1+1/3x^0")
test(b.degree, 2)
test(multia, "(3y^1+1y^0)x^3+(-6y^2+0y^1+0y^0)x^2+(0)x^1+(4)x^0")
test(multia.degree, 3)
endtest()

starttest("polynomial-expression conversion")
test(a:tocompoundexpression():autosimplify():topolynomial(), a)
test(b:tocompoundexpression():autosimplify():topolynomial(), b)
test(c:tocompoundexpression():autosimplify():topolynomial(), c)
endtest()

starttest("polynomial arithmetic")
test(a + a, "10x^4+8x^3+6x^2+4x^1+2x^0")
test(a + b, "5x^4+4x^3+5x^2+25/12x^1+4/3x^0")
test(b + a, "5x^4+4x^3+5x^2+25/12x^1+4/3x^0")
test(a - a, "0x^0")
test(a - b, "5x^4+4x^3+1x^2+23/12x^1+2/3x^0")
test(b:multiplyDegree(4), "2x^6+1/12x^5+1/3x^4+0x^3+0x^2+0x^1+0x^0")
test(a:multiplyDegree(12), "5x^16+4x^15+3x^14+2x^13+1x^12+0x^11+0x^10+0x^9+0x^8+0x^7+0x^6+0x^5+0x^4+0x^3+0x^2+0x^1+0x^0")
test(c * c, "16x^2+96x^1+144x^0")
test(a * c, "20x^5+76x^4+60x^3+44x^2+28x^1+12x^0")
test(c * a, "20x^5+76x^4+60x^3+44x^2+28x^1+12x^0")
test(b * c, "8x^3+73/3x^2+7/3x^1+4x^0")
local qq, rr = a:divremainder(c)
test(qq, "5/4x^3+-11/4x^2+9x^1+-53/2x^0")
test(rr, "319x^0")
qq, rr = a:divremainder(b)
test(qq, "5/2x^2+91/48x^1+1157/1152x^0")
test(rr, "17755/13824x^1+2299/3456x^0")
endtest()

starttest("polynomial pseudodivision")
local pq, pr = a:pseudodivide(c)
test(pq, "320x^3+-704x^2+2304x^1+-6784x^0")
test(pr, "81664x^0")

pq, pr = multia:pseudodivide(multib)
test(pq, "(36y^2+0y^1+-4y^0)x^1+(-72y^3+24y^2+0y^1+0y^0)x^0")
test(pr, "(-216y^3+0y^2+24y^1+0y^0)x^1+(432y^4+-144y^3+576y^2+-384y^1+64y^0)x^0")
endtest()


starttest("combined polynomial/coefficient operations")
test(a + x, "5x^4+4x^3+3x^2+2x^1+4x^0")
test(x + a, "5x^4+4x^3+3x^2+2x^1+4x^0")
test(b - y, "2x^2+1/12x^1+1/2x^0")
test(a * x, "15x^4+12x^3+9x^2+6x^1+3x^0")
test(x * a, "15x^4+12x^3+9x^2+6x^1+3x^0")
endtest()

starttest("polynomial formal derrivatives")
test(a:derrivative(), "20x^3+12x^2+6x^1+2x^0")
test(b:derrivative(), "4x^1+1/12x^0")
test(c:derrivative():derrivative(), "0x^0")
endtest()


starttest("polynomial gcd...")
test(PolynomialRing.gcd(d, e), "1x^1+3x^0")
test(PolynomialRing.gcd(b, c), "1x^0")
test(PolynomialRing.gcd(f, g), "1x^2+2/3x^1+1/9x^0")
endtest()

starttest("square-free factorization")
test(h:squarefreefactorization(),  "(1 * (1x^2+3x^1+2x^0 ^ 1))")
test(i:squarefreefactorization(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 3))")
test((Integer(2)*i):squarefreefactorization(), "(2 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 3))")
test(j:squarefreefactorization(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 2) * (1x^1+3x^0 ^ 3))")
test(o:squarefreefactorization(), "(1 * (1x^6+10x^5+36x^4+60x^3+59x^2+50x^1+24x^0 ^ 1))")
endtest()

starttest("polynomial factorization")
test(c:factor(), "(4 * (1x^1+3x^0 ^ 1))", c)
test(h:factor(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 1))", h)
test(k:factor(), "(1 * (1x^1+5x^0 ^ 1) * (1x^1+6x^0 ^ 1))", k)
test(j:factor(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 2) * (1x^1+3x^0 ^ 3))", j)
test(p:factor(), "(1 * (1x^1+-24x^0 ^ 1) * (1x^2+-24x^1+48x^0 ^ 1) * (1x^2+0x^1+96x^0 ^ 1))", p)
test(l:factor(), "(1 * (1z^1+1z^0 ^ 1) * (1z^1+2z^0 ^ 1) * (1z^1+3z^0 ^ 1))", l)
test(m:factor(), "(1 * (1x^1+1x^0 ^ 10))", m)
test(b:factor(), "(1/12 * (24x^2+1x^1+4x^0 ^ 1))", b)
test(o:factor(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 1) * (1x^1+4x^0 ^ 1) * (1x^1+3x^0 ^ 1) * (1x^2+0x^1+1x^0 ^ 1))", o)
test(n:factor(), "(1 * (1x^1+1x^0 ^ 1) * (1x^1+2x^0 ^ 1) * (1x^1+4x^0 ^ 1) * (1x^1+3x^0 ^ 1) * (1x^2+0x^1+1x^0 ^ 1) * (1x^4+0x^3+-1x^2+0x^1+1x^0 ^ 1))", n)
endtest()

starttest("polynomial decomposition")
test(ToStringArray(c:decompose()), "{4x^1+12x^0}", c)
test(ToStringArray(h:decompose()), "{1x^2+3x^1+2x^0}", h)
test(ToStringArray(k:decompose()), "{1x^2+11x^1+30x^0}", k)
test(ToStringArray(j:decompose()), "{1x^6+14x^5+80x^4+238x^3+387x^2+324x^1+108x^0}", j)
test(ToStringArray(l:decompose()), "{1z^3+6z^2+11z^1+6z^0}", l)
test(ToStringArray(m:decompose()), "{1x^2+2x^1+0x^0, 1x^5+5x^4+10x^3+10x^2+5x^1+1x^0}", m)
test(ToStringArray(b:decompose()), "{2x^2+1/12x^1+1/3x^0}", b)
test(ToStringArray(o:decompose()), "{1x^6+10x^5+36x^4+60x^3+59x^2+50x^1+24x^0}", o)
test(ToStringArray(n:decompose()), "{1x^10+10x^9+35x^8+50x^7+24x^6+0x^5+1x^4+10x^3+35x^2+50x^1+24x^0}", n)
test(ToStringArray(q:decompose()), "{1z^2+-1/2z^1+0z^0, 36z^2+18z^1+3z^0}", q)
test(ToStringArray(r:decompose()),"{1x^2+0x^1+0x^0, 4x^3+0x^2+0x^1+0x^0}", r)
test(ToStringArray(s:decompose()), "{1x^2+0x^1+-4x^0, 1x^2+4x^1+1x^0}", s)
endtest()