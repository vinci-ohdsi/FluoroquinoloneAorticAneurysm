library(testthat)
library(Eunomia)
connectionDetails <- Eunomia::getEunomiaConnectionDetails()
Eunomia::createCohorts(connectionDetails)
endDateFixSql <-"update main.cohort set cohort_end_date = dateadd(d,1, cohort_start_date) where cohort_end_date is null"
conn <- DatabaseConnector::connect(connectionDetails = connectionDetails)
DatabaseConnector::renderTranslateExecuteSql(connection = conn, sql = endDateFixSql)
DatabaseConnector::dbDisconnect(conn)


workFolder <- tempfile("work")
dir.create(workFolder)
resultsfolder <- tempfile("results")
dir.create(resultsfolder)
jobContext <- readRDS("tests/testJobContext.rds")
jobContext$moduleExecutionSettings$workSubFolder <- workFolder
jobContext$moduleExecutionSettings$resultsSubFolder  <- resultsfolder
jobContext$moduleExecutionSettings$connectionDetails <- connectionDetails

test_that("Run module", {
  source("Main.R")
  execute(jobContext)
  resultsFiles <- list.files(resultsfolder)
  expect_true("ci_incidence_summary.csv" %in% resultsFiles)
})

unlink(workFolder)
unlink(resultsfolder)
unlink(connectionDetails$server())
