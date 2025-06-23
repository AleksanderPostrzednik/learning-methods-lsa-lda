cols <- colnames(
  readr::read_csv("data/student_performance_large_dataset.csv") |>
    janitor::clean_names()
)
stopifnot(all(c("gender", "exam_score_percent") %in% cols))
