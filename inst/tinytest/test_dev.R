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

# load_all returns an environment populated with sourced functions,
# without touching the search path.
e <- tinypkgr::load_all(tmp_pkg, quiet = TRUE)
expect_true(is.environment(e))
expect_true("add" %in% ls(e))
expect_equal(e$add(2, 3), 5)
expect_false(any(grepl("testpkg", search())))

# Caller may supply their own env
target <- new.env()
e2 <- tinypkgr::load_all(tmp_pkg, env = target, quiet = TRUE)
expect_identical(e2, target)
expect_true("add" %in% ls(target))

# Clean up temp package
unlink(tmp_pkg, recursive = TRUE)
