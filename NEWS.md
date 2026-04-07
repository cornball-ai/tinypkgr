# tinypkgr 0.2.0

* New `create_package()` for scaffolding a tinyverse-flavored R package: DESCRIPTION with Authors@R, NAMESPACE, .Rbuildignore, NEWS.md, tests/tinytest.R entry point, and an optional starter `hello()` function with matching tinytest test.
* New `use_version()` bumps the DESCRIPTION Version field and prepends a matching NEWS.md section header. Supports `patch`, `minor`, `major`, and `dev` bumps.

# tinypkgr 0.1.0

* Initial CRAN release.
* Development utilities: `install()`, `load_all()`, `reload()`, `check()`.
* Release utilities: `build()`, `maintainer()`, `check_win_devel()`, `submit_cran()`.
