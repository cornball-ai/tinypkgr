#' Check Package
#'
#' Runs R CMD build and R CMD check on the package.
#'
#' @param path Path to package root directory.
#' @param args Character vector of additional arguments to pass to R CMD check.
#'   Default includes "--as-cran" and "--no-manual".
#' @param error_on Severity level that causes an error: "error", "warning", or
#'   "note". Default is "warning" (fails on errors or warnings).
#'
#' @return TRUE if check passes, FALSE otherwise (invisibly).
#'   Also throws an error if check fails at or above error_on level.
#'
#' @export
#'
#' @examples
#' # Runs 'R CMD build' + 'R CMD check' (typically tens of seconds).
#' # Intermediate files go under tempdir(), so nothing is written to the
#' # caller's working directory. Wrapped in if(interactive()) so the
#' # example is shown to users but not executed during R CMD check.
#' \donttest{
#' if (interactive()) {
#'   check()
#'   check(error_on = "error")
#'   check(args = c("--as-cran", "--no-manual"))
#' }
#' }
check <- function(path = ".", args = c("--as-cran", "--no-manual"),
                  error_on = c("warning", "error", "note")) {
    error_on <- match.arg(error_on)

    # Get absolute path
    path <- normalizePath(path, mustWork = TRUE)

    # Get package name from DESCRIPTION
    desc_file <- file.path(path, "DESCRIPTION")
    if (!file.exists(desc_file)) {
        stop("No DESCRIPTION file found in ", path, call. = FALSE)
    }

    desc <- read.dcf(desc_file)
    pkg_name <- desc[1, "Package"]
    pkg_version <- desc[1, "Version"]

    # Create temp directory for build/check
    tmp_dir <- tempfile("tinypkgr_check_")
    dir.create(tmp_dir)
    on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

    # Build the package
    message("Building ", pkg_name, "...")
    r_bin <- shQuote(file.path(R.home("bin"), "R"))
    build_cmd <- paste(r_bin, "CMD build", shQuote(path))
    old_wd <- setwd(tmp_dir)
    on.exit(setwd(old_wd), add = TRUE)

    build_result <- system(build_cmd, ignore.stdout = TRUE,
                           ignore.stderr = TRUE)
    if (build_result != 0) {
        # Re-run to show errors
        system(build_cmd)
        stop("R CMD build failed", call. = FALSE)
    }

    # Find the tarball
    tarball <- paste0(pkg_name, "_", pkg_version, ".tar.gz")
    if (!file.exists(tarball)) {
        stop("Expected tarball not found: ", tarball, call. = FALSE)
    }

    # Run R CMD check
    message("Checking ", pkg_name, "...")
    check_cmd <- paste(r_bin, "CMD check", paste(args, collapse = " "),
                       shQuote(tarball))
    check_result <- system(check_cmd)

    # Parse check results
    check_dir <- paste0(pkg_name, ".Rcheck")
    log_file <- file.path(check_dir, "00check.log")

    if (file.exists(log_file)) {
        log <- readLines(log_file, warn = FALSE)

        # Count issues (format: "* checking ... NOTE" or "ERROR: ...")
        errors <- sum(grepl("\\.\\.\\. ERROR$|^ERROR:", log))
        warnings <- sum(grepl("\\.\\.\\. WARNING$|^WARNING:", log))
        notes <- sum(grepl("\\.\\.\\. NOTE$|^NOTE:", log))

        # Print summary
        message("\n", pkg_name, " ", pkg_version, ": ",
                errors, " error(s), ", warnings, " warning(s), ", notes, " note(s)")

        # Determine if we should error
        should_error <- switch(error_on,
                               "note" = errors > 0 || warnings > 0 || notes > 0,
                               "warning" = errors > 0 || warnings > 0,
                               "error" = errors > 0
        )

        if (should_error) {
            stop("R CMD check found issues", call. = FALSE)
        }

        invisible(TRUE)
    } else {
        if (check_result != 0) {
            stop("R CMD check failed", call. = FALSE)
        }
        invisible(TRUE)
    }
}

#' Install Package
#'
#' Wrapper around R CMD INSTALL with quiet mode option.
#'
#' @param path Path to package root directory.
#' @param quiet Logical. Suppress output except errors? Default TRUE.
#'
#' @return TRUE if successful, FALSE otherwise (invisibly).
#'
#' @export
#'
#' @examples
#' # Calls 'R CMD INSTALL', which writes to the user's R library.
#' # Wrapped in if(interactive()) so CRAN's automated checks never
#' # mutate the library.
#' \donttest{
#' if (interactive()) {
#'   install()
#'   install(quiet = FALSE)
#' }
#' }
install <- function(path = ".", quiet = TRUE) {
    # Get absolute path
    path <- normalizePath(path, mustWork = TRUE)

    # Get package name from DESCRIPTION
    desc_file <- file.path(path, "DESCRIPTION")
    if (!file.exists(desc_file)) {
        stop("No DESCRIPTION file found in ", path, call. = FALSE)
    }

    desc <- read.dcf(desc_file)
    pkg_name <- desc[1, "Package"]

    # Build command
    r_bin <- shQuote(file.path(R.home("bin"), "R"))
    cmd <- paste(r_bin, "CMD INSTALL", shQuote(path))

    # Run install (redirect output if quiet)
    if (quiet) {
        # Redirect both stdout and stderr
        if (.Platform$OS.type == "windows") {
            cmd_quiet <- paste(cmd, "> NUL 2>&1")
        } else {
            cmd_quiet <- paste(cmd, "> /dev/null 2>&1")
        }
        result <- system(cmd_quiet)
    } else {
        result <- system(cmd)
    }

    if (result == 0) {
        message("Installed ", pkg_name)
        invisible(TRUE)
    } else {
        message("Install failed for ", pkg_name)
        invisible(FALSE)
    }
}

#' Load All Package Code
#'
#' Sources all R files in a package for interactive development,
#' without requiring a full install.
#'
#' @param path Path to package root directory.
#' @param env Environment to source files into. Defaults to a fresh
#'   environment whose parent is the global environment.
#' @param quiet Logical. Suppress file sourcing messages? Default TRUE.
#'
#' @return The environment into which files were sourced (invisibly).
#'   Does not modify the search path. If you want search-path behavior,
#'   call `attach()` yourself:
#'   \preformatted{attach(tinypkgr::load_all(), name = "tinypkgr:mypkg")}
#'
#' @seealso \code{\link[pkgKitten]{kitten}} for scaffolding a new package.
#'
#' @export
#'
#' @examples
#' # Scaffold a throwaway package in tempdir() and source its R/ files.
#' pkg <- file.path(tempdir(), "loadpkg")
#' dir.create(file.path(pkg, "R"), recursive = TRUE, showWarnings = FALSE)
#' writeLines(c(
#'   "Package: loadpkg",
#'   "Title: Example",
#'   "Version: 0.0.1",
#'   "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
#'   "Description: Example.",
#'   "License: GPL-3"
#' ), file.path(pkg, "DESCRIPTION"))
#' writeLines("add <- function(x, y) x + y", file.path(pkg, "R", "add.R"))
#'
#' e <- load_all(pkg)
#' e$add(2, 3)
#'
#' unlink(pkg, recursive = TRUE)
load_all <- function(path = ".", env = new.env(parent = globalenv()),
                     quiet = TRUE) {
    r_dir <- file.path(path, "R")

    if (!dir.exists(r_dir)) {
        stop("No R/ directory found in ", path, call. = FALSE)
    }

    r_files <- list.files(r_dir, pattern = "\\.[Rr]$", full.names = TRUE)

    if (length(r_files) == 0) {
        message("No R files found.")
        return(invisible(env))
    }

    for (f in r_files) {
        if (!quiet) {
            message("Sourcing ", basename(f))
        }
        source(f, local = env)
    }

    message("Loaded ", length(r_files), " file(s)")
    invisible(env)
}

#' Reload an Installed Package
#'
#' Unloads a package if loaded, reinstalls it, and loads it again.
#' Convenience function for the install-reload cycle during development.
#'
#' @param path Path to package root directory.
#' @param document If TRUE and tinyrox is available, run tinyrox::document()
#'   before installing. Default FALSE.
#' @param quiet Logical. Suppress install output? Default TRUE.
#'
#' @return TRUE if successful (invisibly).
#'
#' @export
#'
#' @examples
#' # Calls install() under the hood, which writes to the user's R
#' # library. Wrapped in if(interactive()) so checks never mutate it.
#' \donttest{
#' if (interactive()) {
#'   reload()
#'   reload(document = TRUE)
#' }
#' }
reload <- function(path = ".", document = FALSE, quiet = TRUE) {
    # Get package name from DESCRIPTION
    desc_file <- file.path(path, "DESCRIPTION")
    if (!file.exists(desc_file)) {
        stop("No DESCRIPTION file found in ", path,
             ". Is this an R package?", call. = FALSE)
    }

    desc <- read.dcf(desc_file)
    pkg_name <- desc[1, "Package"]

    # Document first if requested
    if (document) {
        if (requireNamespace("tinyrox", quietly = TRUE)) {
            tinyrox::document(path)
        } else {
            warning("tinyrox not available, skipping documentation",
                    call. = FALSE)
        }
    }

    # Unload package if loaded
    pkg_loaded <- paste0("package:", pkg_name)
    if (pkg_loaded %in% search()) {
        tryCatch({
            detach(pkg_loaded, unload = TRUE, character.only = TRUE)
            message("Unloaded ", pkg_name)
        }, error = function(e) {
            # Sometimes unload fails due to dependencies, just detach
            tryCatch({
                detach(pkg_loaded, character.only = TRUE)
                message("Detached ", pkg_name, " (could not fully unload)")
            }, error = function(e2) {
                message("Note: Could not detach ", pkg_name, ": ", e2$message)
            })
        })
    }

    # Also unload namespace if still loaded
    if (pkg_name %in% loadedNamespaces()) {
        tryCatch({
            unloadNamespace(pkg_name)
        }, error = function(e) {
            # Ignore - will be handled by library() reload
        })
    }

    # Reinstall
    success <- install(path, quiet = quiet)

    if (success) {
        # Reload
        library(pkg_name, character.only = TRUE)
        message("Reloaded ", pkg_name)
    }

    invisible(success)
}

