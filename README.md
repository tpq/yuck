
<!-- README.md is generated from README.Rmd. Please edit that file -->
Introduction
------------

We all know R is not the place to write for-loops, but some of us really, really like them. This package is inspired by Python's list comprehensions that make it possible to write for-loops in only a few keystrokes. Note that this package makes for-loops faster to write, not faster to run.

You can install the most recent version of `yuck` from GitHub:

``` r
devtools::install_github("tpq/yuck")
library(yuck)
```

Single loop comprehensions
--------------------------

A list comprehension allows a user to step through a for-loop and save each result in one line of code, similar to what `lapply` does. The `yuck` package introduces the `:=` operator to trigger a list comprehension by computing the expression on the right and saving it to the value on the left.

``` r
a := for(i in 1:5) i^2
a
#> [1]  1  4  9 16 25
```

Nested loop comprehensions
--------------------------

The `yuck` package allows for nested loop comprehensions.

``` r
a := for(i in 1:5) for(j in 1:7) i * j
a
#>  [1]  1  2  3  4  5  6  7  2  4  6  8 10 12 14  3  6  9 12 15 18 21  4  8
#> [24] 12 16 20 24 28  5 10 15 20 25 30 35
```

See the vignette for more details.
