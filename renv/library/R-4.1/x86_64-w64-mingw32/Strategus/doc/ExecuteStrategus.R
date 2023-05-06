## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----eval=FALSE---------------------------------------------------------------
## library(Strategus)
## folder <- "c:/strategus"

## ----echo=FALSE, warning=FALSE, message=FALSE---------------------------------
library(Strategus)
outputFolder <- tempfile("vignetteFolder")
dir.create(outputFolder)


## -----------------------------------------------------------------------------
# Note: specifying the `databaseFile` so the Eunomia database is permanent, not temporary:
connectionDetails <- Eunomia::getEunomiaConnectionDetails(
  databaseFile = file.path(outputFolder, "cdm.sqlite")
)


## ----eval=FALSE---------------------------------------------------------------
## storeConnectionDetails(
##   connectionDetails = connectionDetails,
##   connectionDetailsReference = "eunomia"
## )


## -----------------------------------------------------------------------------
executionSettings <- createCdmExecutionSettings(
  connectionDetailsReference = "eunomia",
  workDatabaseSchema = "main",
  cdmDatabaseSchema = "main",
  cohortTableNames = CohortGenerator::getCohortTableNames(),
  workFolder = file.path(outputFolder, "work_folder"),
  resultsFolder = file.path(outputFolder, "results_folder"),
  minCellCount = 5
)


## -----------------------------------------------------------------------------
ParallelLogger::saveSettingsToJson(
  object = executionSettings,
  file.path(outputFolder, "eunomiaExecutionSettings.json")
)


## ----eval=FALSE---------------------------------------------------------------
## Sys.setenv("INSTANTIATED_MODULES_FOLDER" = "c:/strategus/modules")


## -----------------------------------------------------------------------------
analysisSpecifications <- ParallelLogger::loadSettingsFromJson(
  fileName = system.file("testdata/analysisSpecification.json",
    package = "Strategus"
  )
)

executionSettings <- ParallelLogger::loadSettingsFromJson(
  fileName = file.path(outputFolder, "eunomiaExecutionSettings.json")
)


## ----eval=FALSE---------------------------------------------------------------
## execute(
##   analysisSpecifications = analysisSpecifications,
##   executionSettings = executionSettings,
##   executionScriptFolder = file.path(outputFolder, "script_folder")
## )


## ----echo=FALSE---------------------------------------------------------------
unlink(outputFolder, recursive = TRUE)

