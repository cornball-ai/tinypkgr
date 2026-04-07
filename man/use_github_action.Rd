% tinyrox says don't edit this manually, but it can't stop you!
\name{use_github_action}
\alias{use_github_action}
\title{Add a GitHub Actions CI Workflow}
\usage{
use_github_action(path = ".")
}
\arguments{
\item{path}{Path to package root directory.}
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
\dontrun{
use_github_action()
}
}
