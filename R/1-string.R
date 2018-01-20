#' Use Regex to Extract Text
#' 
#' \code{string.extract} locates
#' and returns...
#' 
string.extract <- function(x, match){
  
  # Match regular expression and index location
  regr <- gregexpr(match, x)[[1]]
  if(regr[1] == -1) stop("No matches found.")
  start <- regr
  end <- regr + attr(regr, "match.length") - 1
  
  source <- unlist(strsplit(x, split = ""))
  sink <- source
  
  sub <- lapply(1:length(start), function(i) start[i]:end[i])
  unlist(lapply(sub, function(x) paste(sink[x], collapse = "")))
}

#' Use Regex to Append Text
string.append <- function(x, match, text, last = FALSE){
  
  # Match regular expression and index location
  regr <- gregexpr(match, x)[[1]]
  if(regr[1] == -1) stop("No matches found.")
  index <- regr + attr(regr, "match.length") - 1
  
  
  source <- unlist(strsplit(x, split = ""))
  sink <- source
  if(last){
    sink[index[length(index)]] <- paste0(source[index[length(index)]], "~")
  }else{
    for(i in index){
      sink[index] <- paste0(source[index], "~")
    }
  }
  
  sink <- paste(sink, collapse = "")
  gsub("~", text, sink)
}

string.collapse <- function(x){
  
  paste(x, collapse = "")
}

string.explode <- function(x){
  
  unlist(strsplit(x, split = ""))
}

`%+%` <- function(e1, e2){
  
  paste0(e1, e2)
}

string.call <- function(x){
  
  env <- parent.frame()
  eval(parse(text = x), envir = env)
}

`:=` <- function(left, right){
  
  # Turn code into string
  expr <- deparse(substitute(right))
  
  # Pull out iterators
  iters <- string.extract(expr, "for \\([[:alnum:]] in")
  iters <- gsub("for \\(", "", iters)
  iter <- gsub(" in", "", iters)
  
  # Pull out ranges
  rangs <- gsub("for", "\t", expr) # Add break point for nested for-loops
  rangs <- string.extract(rangs, "in [[:print:]]+\\) ")
  rangs <- gsub("in ", "", rangs)
  rangs <- gsub("\\) ", "", rangs)
  rang <- sapply(lapply(rangs, string.call), length)
  
  # Define output result container
  loop.pre <- 'out9000 <- vector("list", ' %+% prod(rang) %+% '); counter <- 0;'
  loop.end <- "}}"
  
  # Find final for-loop call
  loop.final <- rangs[length(rangs)]
  loop.final <- gsub("\\(", "\\\\(", loop.final)
  loop.final <- gsub("\\)", "\\\\)", loop.final)
  loop.final <- gsub("\\+", "\\\\+", loop.final)
  loop.final.index <- loop.final %+% "\\)"
  
  # Add counter after final for-loop call
  counter.start <- "{ counter <- counter + 1; out9000[counter] <- {"
  loop.mid <- string.append(expr, loop.final.index, counter.start, last = TRUE)
  
  # Run for-loop
  loop.final <- loop.pre %+% loop.mid %+% loop.end
  string.call(loop.final)
  
  # Decide whether to unlist
  if(all(sapply(out9000, is.numeric)) | all(sapply(out9000, is.character))){
    out9000 <- unlist(out9000)
  }
  
  # Assign value
  env <- parent.frame()
  assign(deparse(substitute(left)), out9000, envir = env)
  invisible(NULL)
}

a := for(i in 1:5) i^2
a
b := for(i in 1:5) for(j in 1:7) i * j
b

matrix(b, 7, 5)

c := for(i in 1:5) for(j in 1:2) paste("this is how we comprehend:", i, "and", j, "baby")
c

d := for(i in c(1, 2, 3)) i^2
d

e := for(i in c(1, 2, 3)) for(j in c("ok now", "whooo")) paste("yes", i, j)
e


f := for(i in seq(1, 5, .5)) for(j in c("ok now", "whooo")) paste("yes", i, j)
f

#' g is a protected word, so it'll break the regex :X
g := for(i in c(1, 2, 3)) for(j in c("for now", "whooo")) paste("yes", i, j)
g

g := for(i in c(1, 2, 3)) for(j in c("in go", "whooo")) paste("yes", i, j)
g

h := for(i in c(1, 2, 3)) for(j in c("~", "whooo")) paste("yes", i, j)
h

i := for(i in c(1, 2, 3)) for(j in c("out9000", "whooo")) paste("yes", i, j)
i


## PRTOECTED TERMS
# these will break the comprehension:
# for
# in
# ~

#install.packages("microbenchmark")

#The implementation is `yuck`. R struggles with `for`-loops.

microbenchmark::microbenchmark(
  a := for(i in 1:10000) i^2,
  a <- sapply(1:10000, function(i) i^2),
  a <- lapply(1:10000, function(i) i^2),
  a <- (1:10000)^2)

microbenchmark::microbenchmark(
  a := for(i in 1:100000) i^2,
  a <- sapply(1:100000, function(i) i^2),
  a <- lapply(1:100000, function(i) i^2),
  a <- (1:100000)^2)
