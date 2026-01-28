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

# Test quiet install
result <- tinypkgr::install(tmp_pkg, quiet = TRUE)
expect_true(result)

# Test load_all
files <- tinypkgr::load_all(tmp_pkg, quiet = TRUE)
expect_equal(length(files), 1)
expect_true(any(grepl("tinypkgr:testpkg", search())))

# Clean up search path
if ("tinypkgr:testpkg" %in% search()) {
  detach("tinypkgr:testpkg", character.only = TRUE)
}

# Clean up temp package
unlink(tmp_pkg, recursive = TRUE)
