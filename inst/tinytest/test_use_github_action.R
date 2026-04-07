# Tests for use_github_action()

# Inline minimal scaffold (no create_package dependency)
tmp_pkg <- file.path(tempdir(), "ghapkg")
if (dir.exists(tmp_pkg)) unlink(tmp_pkg, recursive = TRUE)
dir.create(tmp_pkg)
writeLines(c(
  "Package: ghapkg",
  "Title: Test",
  "Version: 0.0.1",
  "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut', 'cre'))",
  "Description: Test.",
  "License: GPL-3"
), file.path(tmp_pkg, "DESCRIPTION"))
writeLines("^cran-comments\\.md$", file.path(tmp_pkg, ".Rbuildignore"))

yaml <- tinypkgr::use_github_action(path = tmp_pkg)
expect_true(file.exists(yaml))
expect_equal(basename(yaml), "ci.yaml")
expect_equal(basename(dirname(yaml)), "workflows")

content <- readLines(yaml)
expect_true(any(grepl("^name: ci", content)))
expect_true(any(grepl("eddelbuettel/github-actions/r-ci@master", content)))
expect_true(any(grepl("macos-latest", content)))
expect_true(any(grepl("ubuntu-latest", content)))

# .Rbuildignore got the .github entry appended
rbi <- readLines(file.path(tmp_pkg, ".Rbuildignore"))
expect_true("^\\.github$" %in% rbi)
expect_equal(sum(rbi == "^\\.github$"), 1)

# Calling again errors
expect_error(tinypkgr::use_github_action(path = tmp_pkg))

# Works on a package without an .Rbuildignore
bare <- file.path(tempdir(), "bare_for_ghaction")
if (dir.exists(bare)) unlink(bare, recursive = TRUE)
dir.create(bare)
writeLines(c("Package: bare", "Version: 0.0.0.1",
    "Title: Bare", "Description: x.", "License: GPL-3"),
  file.path(bare, "DESCRIPTION"))
tinypkgr::use_github_action(path = bare)
expect_true(file.exists(file.path(bare, ".Rbuildignore")))
expect_true("^\\.github$" %in% readLines(file.path(bare, ".Rbuildignore")))

unlink(tmp_pkg, recursive = TRUE)
unlink(bare, recursive = TRUE)
