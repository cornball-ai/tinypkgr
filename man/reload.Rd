% tinyrox says don't edit this manually, but it can't stop you!
\name{reload}
\alias{reload}
\title{Reload an Installed Package}
\usage{
reload(path = ".", document = FALSE, quiet = TRUE)
}
\arguments{
\item{path}{Path to package root directory.}

\item{document}{If TRUE and tinyrox is available, run tinyrox::document()
before installing. Default FALSE.}

\item{quiet}{Logical. Suppress install output? Default TRUE.}
}
\value{
TRUE if successful (invisibly).
}
\description{
Unloads a package if loaded, reinstalls it, and loads it again.
Convenience function for the install-reload cycle during development.
}
\examples{
# Calls install() under the hood, which writes to the user's R
# library. Wrapped in if(interactive()) so checks never mutate it.
\donttest{
if (interactive()) {
  reload()
  reload(document = TRUE)
}
}
}
