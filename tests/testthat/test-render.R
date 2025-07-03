test_that("slides render correctly", {
  system("bash scripts/render_slides.sh", intern = TRUE)
  expect_true(file.exists("quarto/learning_lsa_lda.html"))
  expect_gt(file.info("quarto/learning_lsa_lda.html")$size, 0)
})
