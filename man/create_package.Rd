% tinyrox says don't edit this manually, but it can't stop you!
\name{create_package}
\alias{create_package}
\title{Create a New R Package}
\usage{
create_package(name, path = ".",
               title = "What The Package Does (One Line, Title Case)",
               description = "A paragraph describing what the package does.",
               author, email, orcid = NULL, license = "GPL-3", example_fn = TRUE)
}
\arguments{
\item{name}{Package name. Must start with a letter and contain only letters,
numbers, and dots.}

\item{path}{Directory in which to create the package. The package itself
will be created at `file.path(path, name)`. Default is the current
directory.}

\item{title}{One-line title in title case (no period).}

\item{description}{Paragraph describing what the package does.}

\item{author}{Author full name (e.g., "First Last").}

\item{email}{Author email address. Also used as the maintainer.}

\item{orcid}{Optional ORCID identifier (e.g., "0000-0000-0000-0000"). If
supplied, added as `comment = c(ORCID = ...)` in Authors@R.}

\item{license}{License string for the License field. Default "GPL-3".}

\item{example_fn}{If TRUE (default), write a starter `R/hello.R` with a
tinyrox-documented `hello()` function and a matching tinytest test.}
}
\value{
Path to the created package directory (invisibly).
}
\description{
Scaffolds a minimal tinyverse-flavored R package: DESCRIPTION with Authors@R,
NAMESPACE, .Rbuildignore, NEWS.md, a tinytest entry point, and (optionally)
a starter function plus matching test.
}
\examples{
\donttest{
tmp <- tempfile("tinypkgr_create_")
dir.create(tmp)
create_package("mypkg", path = tmp,
               author = "First Last",
               email = "you@example.com")
unlink(tmp, recursive = TRUE)
}
}
