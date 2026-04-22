% tinyrox says don't edit this manually, but it can't stop you!
\name{submit_cran}
\alias{submit_cran}
\title{Submit Package to CRAN}
\usage{
submit_cran(path = ".", comments = "cran-comments.md")
}
\arguments{
\item{path}{Path to package root directory.}

\item{comments}{Path to cran-comments.md file, or NULL to skip.}
}
\value{
TRUE if submission succeeded (invisibly).
}
\description{
Uploads package to CRAN for review. You will receive a confirmation email
that must be clicked to complete the submission.
}
\examples{
# Uploads to CRAN and prompts interactively for confirmation.
# Wrapped in if(interactive()) so CRAN's automated checks never
# attempt the upload.
\donttest{
if (interactive()) {
  submit_cran()
}
}
}
