#' Using mixed methods to visualize a correlation matrix.
#'
#' @param corr Matrix, the correlation matrix to visualize.
#' @param lower Character, the visualization method for the lower triangular
#'   correlation matrix.
#' @param upper Character, the visualization method for the upper triangular
#'   correlation matrix.
#' @param tl.pos Character, \code{"lt"}, \code{"d"} or \code{"n"}, giving
#'   position of text labels, \code{"lt"} means left and top,  \code{"d"} means
#'   diagonal. If \code{"n"},  add no textlabel.
#' @param diag Character, for specifying the glyph on the principal diagonal. It
#'   is one of \code{"n"} (default,  draw nothing), \code{"l"} (draw the glyphs
#'   of lower triangular) or \code{"u"} (draw the glyphs of upper triangular).
#' @param bg The background color.
#' @param addgrid.col See the \code{addgrid.col} parameter in the function
#'   \code{\link{corrplot}}
#' @param plotCI See the \code{plotCI} parameter in the function
#'   \code{\link{corrplot}}
#' @param \dots Additional arguments for corrplot's wrappers
#'
#' @author Taiyun Wei
#' @example vignettes/example-corrplot.mixed.R
#' @export
corrplot.mixed <- function(corr, lower = "number",
  upper = "circle", tl.pos = c("d", "lt", "n"),
  diag = c("n", "l", "u"), bg = "white", addgrid.col = "grey",
  plotCI = c("n", "square", "circle", "rect"),
  ...)
{
  diag <- match.arg(diag)
  tl.pos <- match.arg(tl.pos)
  n <- nrow(corr)

  # fixes issue #21
  # some methods are not compatible with plotCI="rect"
  adjust_plotCI <- function(plotCI, method) {
    if (plotCI != "rect" ||
        method %in% c("circle", "square")) {
      return(plotCI)
    }
    return("n")
  }

  plotCI_lower <- adjust_plotCI(plotCI, lower)
  plotCI_upper <- adjust_plotCI(plotCI, upper)

  corrplot(corr, type = "upper", method = upper, diag = TRUE,
           tl.pos = tl.pos, plotCI = plotCI_upper, ...)

  corrplot(corr, add = TRUE, type = "lower", method = lower,
           diag = (diag == "l"),
           tl.pos = "n", cl.pos = "n", plotCI = plotCI_lower, ...)

  if (diag == "n" && tl.pos != "d") {
      symbols(1:n, n:1, add = TRUE, bg = bg, fg = addgrid.col,
              inches = FALSE, squares = rep(1, n))
  }

  # fixes issue #43
  # return value should be the same as in the corrplot function
  invisible(corr)
}
