# install.R
# Robust non-interactive installer for project dependencies

# 1. Default CRAN mirror and textdata option
options(repos = c(CRAN = "https://cloud.r-project.org"))
options(textdata.download = TRUE)

# 2. Required packages
pkgs <- c(
  "tidyverse", "janitor", "tidytext", "textdata",
  "topicmodels", "textmineR", "tm", "SnowballC",
  "wordcloud", "knitr", "quarto",
  "lsa", "umap", "plotly", "ggwordcloud"
)

# 3. Helper to install packages with retries
ensure_pkg <- function(pkg, max_attempts = 3) {
  for (i in seq_len(max_attempts)) {
    if (requireNamespace(pkg, quietly = TRUE)) return(TRUE)
    message(sprintf("[INFO] Installing '%s' (attempt %d/%d)...", pkg, i, max_attempts))
    tryCatch({
      if (.Platform$OS.type == "windows" && pkg %in% loadedNamespaces()) {
        try(unloadNamespace(pkg), silent = TRUE)
      }
      install.packages(pkg, dependencies = TRUE)
    }, error = function(e) {
      message("[WARN] ", e$message)
      lock <- file.path(.libPaths()[1], paste0("00LOCK-", pkg))
      if (dir.exists(lock)) unlink(lock, recursive = TRUE, force = TRUE)
      tryCatch(install.packages(pkg, type = "binary", dependencies = TRUE),
               error = function(e2) message("[WARN] binary install failed: ", e2$message))
    })
    if (requireNamespace(pkg, quietly = TRUE)) return(TRUE)
    Sys.sleep(1)
  }
  FALSE
}

# 4. Install required packages
ok_pkgs <- vapply(pkgs, ensure_pkg, logical(1))

# 5. Load textdata and download lexicons
lex_ok <- function(name) {
  out <- FALSE
  tryCatch({
    if (!requireNamespace("textdata", quietly = TRUE)) stop("textdata missing")
    if (exists("download_lexicon", where = asNamespace("textdata"))) {
      textdata::download_lexicon(name)
    } else {
      get(paste0("lexicon_", name), envir = asNamespace("textdata"))(ask = FALSE)
    }
    file <- file.path(textdata::lexicon_cache_dir(), paste0(name, ".rds"))
    out <- file.exists(file)
  }, error = function(e) {
    msg <- sprintf("Run `tidytext::get_sentiments('%s')` once in an interactive R session to cache the file.", name)
    if (!interactive()) message("[WARN] ", e$message, "\n       ", msg)
    else message("[WARN] ", e$message)
  })
  out
}

afinn_ok <- lex_ok("afinn")
nrc_ok   <- lex_ok("nrc")

# 6. Check all packages load
load_ok <- vapply(pkgs, function(p) {
  tryCatch({
    library(p, character.only = TRUE)
    TRUE
  }, error = function(e) FALSE)
}, logical(1))

success <- all(ok_pkgs) && all(load_ok) && afinn_ok && nrc_ok

if (success) {
  cat("\033[32m[SUCCESS]\033[39m Packages and lexicons ready.\n")
} else {
  cat("\033[31m[FAIL]\033[39m Some components failed to install or load.\n")
}

invisible(success)
