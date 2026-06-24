% tinyrox says don't edit this manually, but it can't stop you!
\name{load_all}
\alias{load_all}
\title{Load All Package Code}
\usage{
load_all(path = ".", env = new.env(parent = globalenv()), quiet = TRUE,
         attach = TRUE)
}
\arguments{
\item{path}{Path to package root directory.}

\item{env}{Environment to source files into. Defaults to a fresh
environment whose parent is the global environment.}

\item{quiet}{Logical. Suppress file sourcing messages? Default TRUE.}

\item{attach}{Logical. Attach the sourced environment to the search path as
\code{package:<name>} so its functions are callable directly? Default
TRUE. A previous attachment of the same package is replaced. Set FALSE to
only return the environment without touching the search path. Kept last in
the argument list so positional calls from earlier versions still work.}
}
\value{
The environment into which files were sourced (invisibly).
}
\description{
Sources all R files in a package for interactive development, without a
full install. By default the sourced environment is attached to the search
path (like \code{devtools::load_all()}), so the package's functions are
immediately callable in the session. Help pages are not available this way;
use \code{install()} or \code{reload()} if you need \code{?topic} docs.
}
\examples{
# Scaffold a throwaway package in tempdir() and source its R/ files.
pkg <- file.path(tempdir(), "loadpkg")
dir.create(file.path(pkg, "R"), recursive = TRUE, showWarnings = FALSE)
writeLines(c(
  "Package: loadpkg",
  "Title: Example",
  "Version: 0.0.1",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
  "Description: Example.",
  "License: GPL-3"
), file.path(pkg, "DESCRIPTION"))
writeLines("add <- function(x, y) x + y", file.path(pkg, "R", "add.R"))

# attach = FALSE returns the environment without touching the search path.
e <- load_all(pkg, attach = FALSE)
e$add(2, 3)

unlink(pkg, recursive = TRUE)
}
\seealso{
\code{\link[pkgKitten]{kitten}} for scaffolding a new package.
}
