% tinyrox says don't edit this manually, but it can't stop you!
\name{use_version}
\alias{use_version}
\title{Bump Package Version}
\usage{
use_version(which = c("patch", "minor", "major", "dev"), path = ".")
}
\arguments{
\item{which}{Which component to bump: "patch" (0.2.0 -> 0.2.1),
"minor" (0.2.0 -> 0.3.0), "major" (0.2.0 -> 1.0.0), or
"dev" (0.2.0 -> 0.2.0.9000, or 0.2.0.9000 -> 0.2.0.9001).}

\item{path}{Path to package root directory.}
}
\value{
The new version string (invisibly).
}
\description{
Increments the Version field in DESCRIPTION and prepends a new section
header to NEWS.md (if present) so the two never drift apart.
}
\examples{
\donttest{
tmp <- tempfile("tinypkgr_use_")
dir.create(tmp)
create_package("foo", path = tmp,
               author = "First Last", email = "f@example.com")
use_version("patch", path = file.path(tmp, "foo"))
unlink(tmp, recursive = TRUE)
}
}
