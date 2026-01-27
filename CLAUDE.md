# tinypkgr

Minimal R package development utilities - base R + curl.

## What it does

Lightweight wrappers around R CMD commands and CRAN submission.

## Exports

| Function | Purpose |
|----------|---------|
| `install()` | R CMD INSTALL wrapper |
| `load_all()` | Source R/ files for interactive dev |
| `reload()` | Reinstall and reload package |
| `check()` | R CMD check wrapper |
| `build()` | R CMD build wrapper |
| `maintainer()` | Extract maintainer from DESCRIPTION |
| `check_win_devel()` | Upload to win-builder.r-project.org |
| `submit_cran()` | Submit package to CRAN |

## Usage

```r
tinypkgr::install()
tinypkgr::load_all()
tinypkgr::check()
```

## Alternative: littler scripts

littler provides similar functionality via standalone scripts:

| tinypkgr | littler |
|----------|---------|
| `install()` | `install.r` |
| `check()` | `check.r` |
| `build()` | `build.r` |

littler scripts are in `/usr/lib/R/site-library/littler/examples/`.

Use littler when you want CLI tools. Use tinypkgr when you want R functions (e.g., in scripts or interactive sessions).

## Dependencies

- `curl` (for win-builder and CRAN uploads only)
- `tinyrox` (optional, for `reload(document = TRUE)`)
