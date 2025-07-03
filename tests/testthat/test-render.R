test_that("rendered HTML contains expected heading", {
  skip_if(Sys.which("quarto") == "", "quarto command not found")

  html_file <- file.path("quarto", "learning_lsa_lda.html")
  if (!file.exists(html_file) || file.info(html_file)$size == 0) {
    quarto::quarto_render(file.path("quarto", "learning_lsa_lda.qmd"))
  }

  expect_true(file.exists(html_file))
  lines <- readLines(html_file, warn = FALSE)
  expect_true(any(grepl("Plan prezentacji", lines)))
})
