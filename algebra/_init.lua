-- Loads algebra files in the correct order.
bn = require("_lib.nums.bn")
require("_lib.table.copy")

require("expression._init")

require("algebra.ring")
require("algebra.euclideandomain")
require("algebra.field")
require("algebra.polynomialring")
require("algebra.integer")
require("algebra.rational")