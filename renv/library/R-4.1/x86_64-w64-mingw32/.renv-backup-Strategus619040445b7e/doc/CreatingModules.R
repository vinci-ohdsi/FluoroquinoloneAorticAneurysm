## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
skeletonFolder <- ifelse(basename(getwd()) == "vignettes",
  "module_skeleton",
  file.path("vignettes", "module_skeleton")
)


## ----comment='', echo=FALSE---------------------------------------------------
fs::dir_tree(skeletonFolder, recurse = FALSE, type = "file")


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "MetaData.json")), sep = "\n")


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "Main.R")), sep = "\n")


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "resources", "resultsDataModelSpecification.csv")), sep = "\n")


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "SettingsFunctions.R")), sep = "\n")


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "resources", "exampleAnalysisSpecifications.json")), sep = "\n")


## ----eval=FALSE---------------------------------------------------------------
## OhdsiRTools::createRenvLockFile(
##   rootPackage = "CohortGenerator",
##   includeRootPackage = TRUE,
##   mode = "description",
##   additionalRequiredPackages = c("checkmate", "CirceR")
## )


## ----eval=FALSE---------------------------------------------------------------
## renv::init()


## ----comment='', echo=FALSE---------------------------------------------------
cat(readLines(file.path(skeletonFolder, "extras", "ModuleMaintenance.R")), sep = "\n")

