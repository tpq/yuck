#' @title
#' Ye Upsold Comprehension Kit
#'
#' @description
#' See Examples.
#'
#' @param left The variable to which to assign the output.
#' @param right The for-loop(s) to parse.
#' @param debug A boolean. Toggles whether to print the
#'  final expression parsed by \code{yuck}.
#'
#' @examples
#' \dontrun{
#' a := for(i in 1:5) i^2
#' a
#'
#' a := for(i in 1:5) i %in% 1:4
#' a
#'
#' a := for(i in 1:5) for(j in 1:7) (i - 1)^2 + (j - 1)^2
#' matrix(a, 7, 5)
#' }
#' @name yuck
NULL

#' @name yuck
#' @rdname yuck
#' @export
`:=` <- function(left, right, debug = FALSE){

  # Turn code into string
  expr <- deparse(substitute(right))
  expr <- string.collapse(expr)

  # Pull out iterators
  iters <- string.extract(expr, "for \\([[:print:]]+? in")
  iters <- gsub("for \\(", "", iters)
  iter <- gsub(" in", "", iters)

  # Pull out ranges
  rangs <- gsub("for", "\t", expr) # Add break point for nested for-loops
  rangs <- string.extract(rangs, "in [[:print:]]+?\\) ")
  rangs <- gsub("in ", "", rangs)
  rangs <- gsub("\\) ", "", rangs)

  # Evaluate the ranges in parent environment
  rang <- vector("numeric", length(rangs))
  env <- parent.frame()
  for(r in 1:length(rangs)){
    parentRang <- parse(text = rangs[r])
    rang[r] <- length(eval(parentRang, env))
  }

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
  counter.start <- "{ counter <- counter + 1; out9000[[counter]] <- {"
  loop.mid <- string.append(expr, loop.final.index, counter.start, last = TRUE)

  # Run for-loop
  loop.final <- loop.pre %+% loop.mid %+% loop.end
  if(debug) print(loop.final)

  # Evaluate the loop in parent environment
  env <- parent.frame()
  parentLoop <- parse(text = loop.final)
  eval(parentLoop, env)
  out9000 <- get("out9000", env)

  # Decide whether to unlist
  if(all(sapply(out9000, is.numeric)) |
     all(sapply(out9000, is.character)) |
     all(sapply(out9000, is.logical))){
    if(all(sapply(out9000, length) == 1)){
      out9000 <- unlist(out9000)
    }
  }

  # Assign value
  env <- parent.frame()
  assign(deparse(substitute(left)), out9000, envir = env)
  invisible(NULL)
}
