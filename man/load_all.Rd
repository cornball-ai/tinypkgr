% tinyrox says don't edit this manually, but it can't stop you!
\name{load_all}
\alias{load_all}
\title{Load All Package Code}
\usage{
load_all(path = ".", env = new.env(parent = globalenv()), quiet = TRUE)
}
\arguments{
\item{path}{Path to package root directory.}

\item{env}{Environment to source files into. Defaults to a fresh
environment whose parent is the global environment.}

\item{quiet}{Logical. Suppress file sourcing messages? Default TRUE.}
}
\value{
The environment into which files were sourced (invisibly).
  Does not modify the search path. If you want search-path behavior,
  call `attach()` yourself:
  \preformatted{attach(tinypkgr::load_all(), name = "tinypkgr:mypkg")}
}
\description{
Sources all R files in a package for interactive development,
without requiring a full install.
}
\examples{
\dontrun{
e <- load_all()
e$my_function(123)

# Or attach to the search path explicitly:
attach(load_all(), name = "tinypkgr:mypkg")
}
}
\seealso{
\code{\link[pkgKitten]{kitten}} for scaffolding a new package.
}
