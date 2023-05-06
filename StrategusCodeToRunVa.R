

# start renv
install.packages("renv")
# dir.create(file.path(".", "renv_cache"))
renv::init(bare = T) 

# install the network package
install.packages('remotes')
remotes::install_github("OHDSI/Strategus", ref="results-upload",
                        INSTALL_opts = "--no-multiarch")
remotes::install_github("OHDSI/Eunomia",
                        INSTALL_opts = "-no-multiarch")
renv::snapshot()

##=========== START BEHIND FIREWALL ==========
library(Strategus)

##=========== START OF INPUTS ==========
Sys.setenv(DATABASECONNECTOR_JAR_FOLDER="C:/Db")
connectionDetailsReference <- "VA-OMOP"
workDatabaseSchema <- 'VINCI_OMOP.scratch.msuchard'
cdmDatabaseSchema <- 'CDW_OMOP.OMOPV5'
outputLocation <- 'D:/OHDSI/MAS/output'
minCellCount <- 10
cohortTableName <- "sos_fq_aa"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "sql server",
  server = "vhacdwdwhdbs102"
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


