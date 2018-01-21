#' Use Regex to Extract Text
#'
#' \code{string.extract} uses regular expressions to match a pattern,
#'  then returns all matches.
#'
#' @param x A character string. The text to search.
#' @param match A character string. The regex text to match.
#' @export
string.extract <- function(x, match){

  # Match regular expression and index location
  regr <- gregexpr(match, x)[[1]]
  if(regr[1] == -1) stop("No matches found.")
  start <- regr
  end <- regr + attr(regr, "match.length") - 1

  # Extract text
  source <- string.explode(x)
  sink <- source
  sub <- lapply(1:length(start), function(i) start[i]:end[i])
  unlist(lapply(sub, function(x) string.collapse(sink[x])))
}

#' Use Regex to Append Text
#'
#' \code{string.append} uses regular expressions to match a pattern,
#'  then appends \code{text} at the end of all matches.
#'
#' @inheritParams string.extract
#' @param text A character string. The text to append.
#' @param last A logical. Toggles whether to append only the
#'  final match.
#' @export
string.append <- function(x, match, text, last = FALSE){

  # Match regular expression and index location
  regr <- gregexpr(match, x)[[1]]
  if(regr[1] == -1) stop("No matches found.")
  index <- regr + attr(regr, "match.length") - 1

  # Use ~ to mark where to append text
  source <- string.explode(x)
  sink <- source
  if(last){
    sink[index[length(index)]] <- paste0(source[index[length(index)]], "~~~")
  }else{
    for(i in index){
      sink[index] <- paste0(source[index], "~~~")
    }
  }

  # Append text
  sink <- string.collapse(sink)
  gsub("~~~", text, sink)
}

#' Collapse String
#'
#' \code{string.collapse} converts a vector of character strings
#'  to a single character string.
#'
#' @inheritParams string.extract
#' @export
string.collapse <- function(x){

  paste(x, collapse = "")
}

#' Explode String
#'
#' \code{string.explode} converts one character string to a vector
#'  of individual character strings.
#'
#' @inheritParams string.extract
#' @export
string.explode <- function(x){

  unlist(strsplit(x, split = ""))
}

#' Call String
#'
#' \code{string.call} executes a string as an expression.
#'
#' @inheritParams string.extract
#' @export
string.call <- function(x){

  env <- parent.frame()
  eval(parse(text = x), envir = env)
}

#' Paste Strings
#'
#' \code{\%+\%} is a binary operator that wraps \code{paste0}.
#'
#' @param e1,e2 A character string.
#' @export
`%+%` <- function(e1, e2){

  paste0(e1, e2)
}
