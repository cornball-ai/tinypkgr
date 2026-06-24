% tinyrox says don't edit this manually, but it can't stop you!
\name{document}
\alias{document}
\title{Document a Package}
\usage{
document(path = ".", ...)
}
\arguments{
\item{path}{Path to package root directory.}

\item{...}{Further arguments passed to \code{tinyrox::document()}.}
}
\value{
The result of \code{tinyrox::document()} (invisibly).
}
\description{
Generates Rd files and \code{NAMESPACE} from roxygen-style comments using
\pkg{tinyrox}, a lightweight equivalent of \code{devtools::document()}.
tinyrox is an optional (Suggests) dependency; an informative error is
raised if it is not installed.
}
\examples{
# Requires the 'tinyrox' package. Wrapped in if(interactive()) so CRAN's
# automated checks do not depend on a Suggests package being present.
\donttest{
if (interactive() && requireNamespace("tinyrox", quietly = TRUE)) {
  document()
}
}
}
