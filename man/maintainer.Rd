% tinyrox says don't edit this manually, but it can't stop you!
\name{maintainer}
\alias{maintainer}
\title{Get Package Maintainer}
\usage{
maintainer(path = ".")
}
\arguments{
\item{path}{Path to package root directory.}
}
\value{
A list with elements `name` and `email`.
}
\description{
Extracts maintainer name and email from DESCRIPTION.
}
\examples{
# Scaffold a throwaway package in tempdir() and read its maintainer.
pkg <- file.path(tempdir(), "mxpkg")
dir.create(pkg, showWarnings = FALSE)
writeLines(c(
  "Package: mxpkg",
  "Title: Example",
  "Version: 0.0.1",
  "Authors@R: person('Jane', 'Doe', email = 'jane@example.com',",
  "                  role = c('aut','cre'))",
  "Description: Example.",
  "License: GPL-3"
), file.path(pkg, "DESCRIPTION"))

maintainer(pkg)

unlink(pkg, recursive = TRUE)
}
