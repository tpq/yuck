
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
matrix(a, 7, 5)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    1    2    3    4    5
#> [2,]    2    4    6    8   10
#> [3,]    3    6    9   12   15
#> [4,]    4    8   12   16   20
#> [5,]    5   10   15   20   25
#> [6,]    6   12   18   24   30
#> [7,]    7   14   21   28   35
```

Use cases
---------

The examples above are arbitrary and the problems presented have better (i.e., vectorized) solutions. Rather, the advantage of `yuck` comes from its use in combination with others tools. For example, we could use `yuck` to iterate across multiple machine learning parameters, models, and predictions. We can also combine `yuck` with `magrittr` to comprehend pipes.

``` r
library(e1071)
library(magrittr)
data(iris)
groups <- split(sample(1:nrow(iris)), 1:2)
train <- iris[groups[[1]],]
test <- iris[groups[[2]],]
confs := for(kernel in c("linear", "radial", "polynomial"))
  svm(Species ~ ., train, kernel = kernel) %>%
  predict(test) %>% table(test$Species)
confs
#> [[1]]
#>             
#> .            setosa versicolor virginica
#>   setosa         29          0         0
#>   versicolor      0         22         0
#>   virginica       0          2        22
#> 
#> [[2]]
#>             
#> .            setosa versicolor virginica
#>   setosa         29          0         0
#>   versicolor      0         22         1
#>   virginica       0          2        21
#> 
#> [[3]]
#>             
#> .            setosa versicolor virginica
#>   setosa         29          0         0
#>   versicolor      0         23         7
#>   virginica       0          1        15
```

I like using `yuck` to measure CPU time and RAM overhead.

``` r
library(peakRAM)
times := for(i in c(1e5, 1e6, 1e7)) data.frame(i,
  peakRAM(
    function() 1:i,
    1:i,
    1:i + 1:i,
    1:i * 2
  ))[,-3]
times
#> [[1]]
#>       i Function_Call Total_RAM_Used_MiB Peak_RAM_Used_MiB
#> 1 1e+05 function()1:i                0.4               0.4
#> 2 1e+05           1:i                0.4               0.4
#> 3 1e+05       1:i+1:i                0.4               0.8
#> 4 1e+05         1:i*2                0.8               1.2
#> 
#> [[2]]
#>       i Function_Call Total_RAM_Used_MiB Peak_RAM_Used_MiB
#> 1 1e+06 function()1:i                3.9               3.9
#> 2 1e+06           1:i                3.9               3.9
#> 3 1e+06       1:i+1:i                3.9               7.7
#> 4 1e+06         1:i*2                7.7              11.5
#> 
#> [[3]]
#>       i Function_Call Total_RAM_Used_MiB Peak_RAM_Used_MiB
#> 1 1e+07 function()1:i               38.2              38.2
#> 2 1e+07           1:i               38.2              38.2
#> 3 1e+07       1:i+1:i               38.2              76.3
#> 4 1e+07         1:i*2               76.3             114.5
```
