

# start renv
install.packages("renv")
renv::init(bare = T) 

# install the network package
# renv::install('remotes')
# renv::install("renv")
# remotes::install_github("OHDSI/Strategus", ref="results-upload",
#                         INSTALL_opts = "--no-multiarch")
# remotes::install_github("OHDSI/Eunomia",
#                         INSTALL_opts = "-no-multiarch")

renv::install("OHDSI/Strategus@results-upload")
renv::install("OHDSI/Eunomia")

renv::snapshot()

library(Strategus)

##=========== START OF INPUTS ==========

connectionDetailsReference <- "Eunomia"
workDatabaseSchema <- 'main'
cdmDatabaseSchema <- 'main'
outputLocation <- "C:/Users/msuch/Documents/FluoroquinoloneAorticAneurysm/output"
minCellCount <- 10
cohortTableName <- "sos_fq_aa"

connectionDetails <- Eunomia::getEunomiaConnectionDetails(
  databaseFile = file.path(outputLocation, "cdm.sqlite")
)

##=========== END OF INPUTS ==========
##################################
# DO NOT MODIFY BELOW THIS POINT
##################################
analysisSpecifications <- ParallelLogger::loadSettingsFromJson(
  fileName = "inst/analysisSpecification.json"
)

storeConnectionDetails(
  connectionDetails = connectionDetails,
  connectionDetailsReference = connectionDetailsReference
)

executionSettings <- createCdmExecutionSettings(
  connectionDetailsReference = connectionDetailsReference,
  workDatabaseSchema = workDatabaseSchema,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = cohortTableName),
  workFolder = file.path(outputLocation, connectionDetailsReference, "strategusWork"),
  resultsFolder = file.path(outputLocation, connectionDetailsReference, "strategusOutput"),
  minCellCount = minCellCount
)

# Note: this environmental variable should be set once for each compute node
Sys.setenv("INSTANTIATED_MODULES_FOLDER" = file.path(outputLocation, "StrategusInstantiatedModules"))

execute(
  analysisSpecifications = analysisSpecifications,
  executionSettings = executionSettings,
  executionScriptFolder = file.path(outputLocation, connectionDetailsReference, "strategusExecution")
)


