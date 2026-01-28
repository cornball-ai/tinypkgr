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
\dontrun{
maintainer()
}
}
