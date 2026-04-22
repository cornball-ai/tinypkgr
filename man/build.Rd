% tinyrox says don't edit this manually, but it can't stop you!
\name{build}
\alias{build}
\title{Build Package Tarball}
\usage{
build(path = ".", dest_dir = tools::R_user_dir("tinypkgr", "cache"))
}
\arguments{
\item{path}{Path to package root directory.}

\item{dest_dir}{Directory to place the tarball. Defaults to the
per-package user cache dir (`tools::R_user_dir("tinypkgr",
"cache")`), which is CRAN's recommended location for
package-owned output and persists across sessions. Pass an
explicit path to place the tarball somewhere else.}
}
\value{
Path to the built tarball (invisibly).
}
\description{
Builds a source package tarball suitable for CRAN submission.
}
\examples{
# Scaffold a throwaway package in tempdir() and build a source tarball.
pkg <- file.path(tempdir(), "buildpkg")
dir.create(file.path(pkg, "R"), recursive = TRUE, showWarnings = FALSE)
writeLines(c(
  "Package: buildpkg",
  "Title: Example",
  "Version: 0.0.1",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
  "Description: Example.",
  "License: GPL-3"
), file.path(pkg, "DESCRIPTION"))
writeLines("add <- function(x, y) x + y", file.path(pkg, "R", "add.R"))

out <- file.path(tempdir(), "tarballs")
dir.create(out, showWarnings = FALSE)
tarball <- build(pkg, dest_dir = out)
file.exists(tarball)

unlink(pkg, recursive = TRUE)
unlink(out, recursive = TRUE)
}
