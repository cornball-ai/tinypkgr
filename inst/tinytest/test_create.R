# Tests for create_package()

tmp_root <- tempfile("tinypkgr_create_")
dir.create(tmp_root)

# Basic creation with all defaults + example function
pkg_dir <- tinypkgr::create_package(
  "foopkg",
  path = tmp_root,
  author = "First Last",
  email = "first@example.com",
  orcid = "0009-0005-4248-604X"
)

expect_true(dir.exists(pkg_dir))
expect_true(file.exists(file.path(pkg_dir, "DESCRIPTION")))
expect_true(file.exists(file.path(pkg_dir, "NAMESPACE")))
expect_true(file.exists(file.path(pkg_dir, ".Rbuildignore")))
expect_true(file.exists(file.path(pkg_dir, "NEWS.md")))
expect_true(file.exists(file.path(pkg_dir, "tests", "tinytest.R")))
expect_true(file.exists(file.path(pkg_dir, "R", "hello.R")))
expect_true(file.exists(file.path(pkg_dir, "inst", "tinytest", "test_hello.R")))
expect_true(dir.exists(file.path(pkg_dir, "man")))

# DESCRIPTION parses and has expected fields
desc <- read.dcf(file.path(pkg_dir, "DESCRIPTION"))
expect_equal(unname(desc[1, "Package"]), "foopkg")
expect_equal(unname(desc[1, "Version"]), "0.0.0.9000")
expect_equal(unname(desc[1, "License"]), "GPL-3")
expect_true("Authors@R" %in% colnames(desc))

# Authors@R parses and ORCID is included
authors <- eval(parse(text = desc[1, "Authors@R"]))
expect_true(inherits(authors, "person"))
expect_equal(authors$given, "First")
expect_equal(authors$family, "Last")
expect_equal(authors$email, "first@example.com")
expect_equal(unname(authors$comment["ORCID"]), "0009-0005-4248-604X")

# example_fn = FALSE skips starter files
pkg_dir2 <- tinypkgr::create_package(
  "barpkg",
  path = tmp_root,
  author = "Solo",
  email = "solo@example.com",
  example_fn = FALSE
)
expect_false(file.exists(file.path(pkg_dir2, "R", "hello.R")))
expect_false(file.exists(file.path(pkg_dir2, "inst", "tinytest", "test_hello.R")))

# Single-name author works
desc2 <- read.dcf(file.path(pkg_dir2, "DESCRIPTION"))
authors2 <- eval(parse(text = desc2[1, "Authors@R"]))
expect_equal(authors2$given, "Solo")
expect_true(is.null(authors2$comment))

# Invalid names error
expect_error(tinypkgr::create_package("1pkg", path = tmp_root,
    author = "A B", email = "a@b.com"))
expect_error(tinypkgr::create_package("my-pkg", path = tmp_root,
    author = "A B", email = "a@b.com"))
expect_error(tinypkgr::create_package(".foo", path = tmp_root,
    author = "A B", email = "a@b.com"))

# Existing directory errors
expect_error(tinypkgr::create_package("foopkg", path = tmp_root,
    author = "A B", email = "a@b.com"))

# Cleanup
unlink(tmp_root, recursive = TRUE)
