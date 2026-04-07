# Tests for use_version()

# bump_version() unit tests
bump <- tinypkgr:::bump_version
expect_equal(bump("0.2.0", "patch"), "0.2.1")
expect_equal(bump("0.2.0", "minor"), "0.3.0")
expect_equal(bump("0.2.0", "major"), "1.0.0")
expect_equal(bump("0.2.0", "dev"), "0.2.0.1")
expect_equal(bump("0.2.0.1", "dev"), "0.2.0.2")
expect_equal(bump("0.2.0.2", "dev"), "0.2.0.3")
# Release bump from a dev version strips the dev suffix
expect_equal(bump("0.2.0.5", "patch"), "0.2.1")
expect_equal(bump("0.2.0.5", "minor"), "0.3.0")
expect_equal(bump("0.2.0.5", "major"), "1.0.0")
# Garbage
expect_error(bump("foo", "patch"))
expect_error(bump("0.2", "patch"))

# End-to-end on a temp package (inline minimal scaffold)
tmp_pkg <- file.path(tempdir(), "vpkg")
if (dir.exists(tmp_pkg)) unlink(tmp_pkg, recursive = TRUE)
dir.create(tmp_pkg)
writeLines(c(
  "Package: vpkg",
  "Title: Test Package",
  "Version: 0.1.0",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut', 'cre'))",
  "Description: Test.",
  "License: GPL-3"
), file.path(tmp_pkg, "DESCRIPTION"))
writeLines(c("# vpkg 0.1.0", "", "* Initial."),
  file.path(tmp_pkg, "NEWS.md"))

desc_file <- file.path(tmp_pkg, "DESCRIPTION")

# Patch bump updates DESCRIPTION and NEWS.md
v <- tinypkgr::use_version("patch", path = tmp_pkg)
expect_equal(v, "0.1.1")
expect_equal(unname(read.dcf(desc_file)[1, "Version"]), "0.1.1")
news <- readLines(file.path(tmp_pkg, "NEWS.md"))
expect_true(grepl("^# vpkg 0.1.1", news[1]))

# Minor bump
v <- tinypkgr::use_version("minor", path = tmp_pkg)
expect_equal(v, "0.2.0")

# Major bump
v <- tinypkgr::use_version("major", path = tmp_pkg)
expect_equal(v, "1.0.0")

# Dev bump does NOT touch NEWS.md
news_before <- readLines(file.path(tmp_pkg, "NEWS.md"))
v <- tinypkgr::use_version("dev", path = tmp_pkg)
expect_equal(v, "1.0.0.1")
news_after <- readLines(file.path(tmp_pkg, "NEWS.md"))
expect_equal(news_before, news_after)

# Successive dev bumps
v <- tinypkgr::use_version("dev", path = tmp_pkg)
expect_equal(v, "1.0.0.2")

# Missing DESCRIPTION
empty_dir <- file.path(tempdir(), "empty_for_use_version")
if (dir.exists(empty_dir)) unlink(empty_dir, recursive = TRUE)
dir.create(empty_dir)
expect_error(tinypkgr::use_version("patch", path = empty_dir))

unlink(tmp_pkg, recursive = TRUE)
unlink(empty_dir, recursive = TRUE)
