% tinyrox says don't edit this manually, but it can't stop you!
\name{use_version}
\alias{use_version}
\title{Bump Package Version}
\usage{
use_version(which = c("patch", "minor", "major", "dev"), path)
}
\arguments{
\item{which}{Which component to bump: "patch" (0.2.0 -> 0.2.1),
"minor" (0.2.0 -> 0.3.0), "major" (0.2.0 -> 1.0.0), or
"dev" (0.2.0 -> 0.2.0.1, or 0.2.0.1 -> 0.2.0.2).}

\item{path}{Path to package root directory. Required; no default is
provided because this function edits files in `path`, and CRAN
Repository Policy forbids defaulting write paths to the user's
home filespace (which includes `getwd()`).}
}
\value{
The new version string (invisibly).
}
\description{
Increments the Version field in DESCRIPTION and prepends a new section
header to NEWS.md (if present) so the two never drift apart.
}
\examples{
# Scaffold a throwaway package in tempdir() and bump its version.
pkg <- file.path(tempdir(), "vxpkg")
dir.create(pkg, showWarnings = FALSE)
writeLines(c(
  "Package: vxpkg",
  "Title: Example",
  "Version: 0.1.0",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
  "Description: Example.",
  "License: GPL-3"
), file.path(pkg, "DESCRIPTION"))

use_version("patch", path = pkg)
read.dcf(file.path(pkg, "DESCRIPTION"))[1, "Version"]

unlink(pkg, recursive = TRUE)
}
