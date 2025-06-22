stopifnot(all(c("gender","math_score") %in% 
              colnames(readr::read_csv("data/student_performance_large_dataset.csv"))))
