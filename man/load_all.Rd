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

e <- load_all(pkg)
e$add(2, 3)

unlink(pkg, recursive = TRUE)
}
\seealso{
\code{\link[pkgKitten]{kitten}} for scaffolding a new package.
}
