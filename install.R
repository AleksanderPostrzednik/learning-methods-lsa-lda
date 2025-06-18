packages <- c(
  "tidyverse",
  "tidytext",
  "lsa",
  "topicmodels",
  "umap",
  "ggwordcloud",
  "textmineR",
  "plotly"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

invisible(lapply(packages, install_if_missing))
