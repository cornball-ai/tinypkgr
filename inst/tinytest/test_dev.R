# Tests for dev.R

# Create a temp package
tmp_pkg <- file.path(tempdir(), "testpkg")
if (dir.exists(tmp_pkg)) unlink(tmp_pkg, recursive = TRUE)
dir.create(tmp_pkg)
dir.create(file.path(tmp_pkg, "R"))

# Create minimal package
writeLines(c(
  "Package: testpkg",
  "Title: Test Package",
  "Version: 0.0.1",
  "Authors@R: person('Test', 'Person', email = 'test@example.com', role = c('aut', 'cre'))",
  "Description: A test package for tinypkgr unit tests.",
  "License: MIT"
), file.path(tmp_pkg, "DESCRIPTION"))

writeLines("add <- function(x, y) x + y", file.path(tmp_pkg, "R", "add.R"))
writeLines("export(add)", file.path(tmp_pkg, "NAMESPACE"))

# Test quiet install (skip in CI - needs writable library)
if (at_home()) {
  result <- tinypkgr::install(tmp_pkg, quiet = TRUE)
  expect_true(result)
}

# load_all attaches the sourced env to the search path by default, so the
# package's functions are immediately callable. Clean up the attachment after.
e <- tinypkgr::load_all(tmp_pkg, quiet = TRUE)
expect_true(is.environment(e))
expect_true("package:testpkg" %in% search())
expect_equal(add(2, 3), 5)
detach("package:testpkg", character.only = TRUE)
expect_false("package:testpkg" %in% search())

# attach = FALSE returns the env without touching the search path
e2 <- tinypkgr::load_all(tmp_pkg, attach = FALSE, quiet = TRUE)
expect_true("add" %in% ls(e2))
expect_equal(e2$add(2, 3), 5)
expect_false("package:testpkg" %in% search())

# Caller may supply their own env (attach = FALSE keeps the search path clean)
target <- new.env()
e3 <- tinypkgr::load_all(tmp_pkg, attach = FALSE, env = target, quiet = TRUE)
expect_identical(e3, target)
expect_true("add" %in% ls(target))

# document() generates Rd + NAMESPACE via tinyrox when it is installed
if (requireNamespace("tinyrox", quietly = TRUE)) {
  writeLines(c(
    "#' Subtract",
    "#' @param x A number.",
    "#' @param y A number.",
    "#' @return x minus y.",
    "#' @examples sub2(5, 2)",
    "#' @export",
    "sub2 <- function(x, y) x - y"
  ), file.path(tmp_pkg, "R", "sub2.R"))
  suppressWarnings(tinypkgr::document(tmp_pkg))
  expect_true(file.exists(file.path(tmp_pkg, "man", "sub2.Rd")))
  expect_true(any(grepl("sub2", readLines(file.path(tmp_pkg, "NAMESPACE")))))
}

# Clean up temp package
unlink(tmp_pkg, recursive = TRUE)
