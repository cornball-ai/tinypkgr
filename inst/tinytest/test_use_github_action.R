# Tests for use_github_action()

tmp <- tempfile("tinypkgr_useghaction_")
dir.create(tmp)
pkg <- tinypkgr::create_package("ghapkg", path = tmp,
  author = "A B", email = "a@b.com")

yaml <- tinypkgr::use_github_action(path = pkg)
expect_true(file.exists(yaml))
expect_equal(basename(yaml), "ci.yaml")
expect_equal(basename(dirname(yaml)), "workflows")

content <- readLines(yaml)
expect_true(any(grepl("^name: ci", content)))
expect_true(any(grepl("eddelbuettel/github-actions/r-ci@master", content)))
expect_true(any(grepl("macos-latest", content)))
expect_true(any(grepl("ubuntu-latest", content)))

# .Rbuildignore already had ^\.github$ from create_package, no duplication
rbi <- readLines(file.path(pkg, ".Rbuildignore"))
expect_equal(sum(rbi == "^\\.github$"), 1)

# Calling again errors
expect_error(tinypkgr::use_github_action(path = pkg))

# Works on a package without an .Rbuildignore
bare <- file.path(tmp, "bare")
dir.create(bare)
writeLines(c("Package: bare", "Version: 0.0.0.9000",
    "Title: Bare", "Description: x.", "License: GPL-3"),
  file.path(bare, "DESCRIPTION"))
tinypkgr::use_github_action(path = bare)
expect_true(file.exists(file.path(bare, ".Rbuildignore")))
expect_true("^\\.github$" %in% readLines(file.path(bare, ".Rbuildignore")))

unlink(tmp, recursive = TRUE)
