# Tests for use_version()

# bump_version() unit tests
bump <- tinypkgr:::bump_version
expect_equal(bump("0.2.0", "patch"), "0.2.1")
expect_equal(bump("0.2.0", "minor"), "0.3.0")
expect_equal(bump("0.2.0", "major"), "1.0.0")
expect_equal(bump("0.2.0", "dev"), "0.2.0.9000")
expect_equal(bump("0.2.0.9000", "dev"), "0.2.0.9001")
expect_equal(bump("0.2.0.9001", "dev"), "0.2.0.9002")
# Release bump from a dev version strips the dev suffix
expect_equal(bump("0.2.0.9001", "patch"), "0.2.1")
expect_equal(bump("0.2.0.9001", "minor"), "0.3.0")
expect_equal(bump("0.2.0.9001", "major"), "1.0.0")
# Garbage
expect_error(bump("foo", "patch"))
expect_error(bump("0.2", "patch"))

# End-to-end on a temp package
tmp <- tempfile("tinypkgr_useversion_")
dir.create(tmp)
pkg <- tinypkgr::create_package("vpkg", path = tmp,
  author = "A B", email = "a@b.com")
desc_file <- file.path(pkg, "DESCRIPTION")

# Set a known release version to test from
desc_lines <- readLines(desc_file)
desc_lines[grep("^Version:", desc_lines)] <- "Version: 0.1.0"
writeLines(desc_lines, desc_file)

# Patch bump updates DESCRIPTION and NEWS.md
v <- tinypkgr::use_version("patch", path = pkg)
expect_equal(v, "0.1.1")
expect_equal(unname(read.dcf(desc_file)[1, "Version"]), "0.1.1")
news <- readLines(file.path(pkg, "NEWS.md"))
expect_true(grepl("^# vpkg 0.1.1", news[1]))

# Minor bump
v <- tinypkgr::use_version("minor", path = pkg)
expect_equal(v, "0.2.0")

# Major bump
v <- tinypkgr::use_version("major", path = pkg)
expect_equal(v, "1.0.0")

# Dev bump does NOT touch NEWS.md
news_before <- readLines(file.path(pkg, "NEWS.md"))
v <- tinypkgr::use_version("dev", path = pkg)
expect_equal(v, "1.0.0.9000")
news_after <- readLines(file.path(pkg, "NEWS.md"))
expect_equal(news_before, news_after)

# Successive dev bumps
v <- tinypkgr::use_version("dev", path = pkg)
expect_equal(v, "1.0.0.9001")

# Missing DESCRIPTION
expect_error(tinypkgr::use_version("patch", path = tempdir()))

unlink(tmp, recursive = TRUE)
