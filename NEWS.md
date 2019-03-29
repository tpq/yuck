## yuck 0.0.4
---------------------
* Extend `:=` to support bracketed procedures
    * Throw error if a single line of code exceeds 500 characters
    * Collapse each line of the parsed expression with `; `

## yuck 0.0.3
---------------------
* Extend `:=` to work while embedded inside other functions
* Stop export of `string.` backend functions

## yuck 0.0.2
---------------------
* Make iterator and range regex match non-greedy
* Allow for any kind of iterator (including `.` and `_`)
* Add `debug` argument to print final expression
* Add "Use cases" to README and vignette

## yuck 0.0.1
---------------------
* Add `string.` functions to match regular expressions
* Add `:=` method to parse the list comprehensions
* Make README and vignette
