

# start renv
install.packages("renv")
renv::init(bare = T) 

renv::install("OHDSI/Strategus@results-upload")
renv::install("OHDSI/CohortGenerator")
renv::install("OHDSI/Eunomia")
renv::install("keyring")

renv::snapshot()

library(Strategus)

connectionDetailsReference <- "Build"
workDatabaseSchema <- 'temp'
cdmDatabaseSchema <- 'cdm'
outputLocation <- "C:/Users/msuch/Documents/FAA2/output"
minCellCount <- 10
cohortTableName <- "sos_fq_aa"

Sys.setenv(DATABASECONNECTOR_JAR_FOLDER="C:/Db")

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = keyring::key_get("buildServer"),
  user = keyring::key_get("buildUser"),
  password = keyring::key_get("buildPassword"),
  port = 5432
)

dir.create(outputLocation)

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


