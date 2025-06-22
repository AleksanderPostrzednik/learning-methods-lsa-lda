stopifnot(all(c("learning_style","performance") %in% 
              colnames(readr::read_csv("data/student_performance.csv"))))
