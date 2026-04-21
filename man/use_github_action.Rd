% tinyrox says don't edit this manually, but it can't stop you!
\name{use_github_action}
\alias{use_github_action}
\title{Add a GitHub Actions CI Workflow}
\usage{
use_github_action(path)
}
\arguments{
\item{path}{Path to package root directory. Required; no default is
provided so the caller never accidentally writes files into
`getwd()`.}
}
\value{
Path to the created YAML file (invisibly).
}
\description{
Writes `.github/workflows/ci.yaml` using the r-ci template (Ubuntu and
macOS, via `eddelbuettel/github-actions/r-ci@master`). Adds `^\.github$`
to `.Rbuildignore` if not already present.
}
\examples{
# Scaffold a throwaway package in tempdir() and add the workflow.
pkg <- file.path(tempdir(), "ghapkg_example")
dir.create(pkg, showWarnings = FALSE)
writeLines(c(
  "Package: ghapkg",
  "Title: Example",
  "Version: 0.0.1",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
  "Description: Example.",
  "License: GPL-3"
), file.path(pkg, "DESCRIPTION"))

yaml <- use_github_action(path = pkg)
file.exists(yaml)

unlink(pkg, recursive = TRUE)
}
