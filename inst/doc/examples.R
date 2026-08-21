## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 10, fig.height = 6, warning = FALSE, message = FALSE)
library(cgmguru)
library(iglu)
library(ggplot2)
library(dplyr)

# `R CMD check` executes vignettes outside the package source directory.  Resolve
# the examples from the installed package instead of relying on the working
# directory.
examples_dir <- system.file("examples", package = "cgmguru")
stopifnot(dir.exists(examples_dir))

## ----ex-grid------------------------------------------------------------------
source(file.path(examples_dir, "grid.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-detect-all-events-----------------------------------------------------
source(file.path(examples_dir, "detect_all_events.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-detect-hyper----------------------------------------------------------
source(file.path(examples_dir, "detect_hyperglycemic_events.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-detect-hypo-----------------------------------------------------------
source(file.path(examples_dir, "detect_hypoglycemic_events.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-excursion-------------------------------------------------------------
source(file.path(examples_dir, "excursion.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-local-maxima----------------------------------------------------------
source(file.path(examples_dir, "find_local_maxima.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-max-after-------------------------------------------------------------
source(file.path(examples_dir, "find_max_after_hours.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-max-before------------------------------------------------------------
source(file.path(examples_dir, "find_max_before_hours.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-min-after-------------------------------------------------------------
source(file.path(examples_dir, "find_min_after_hours.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-min-before------------------------------------------------------------
source(file.path(examples_dir, "find_min_before_hours.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-maxima-grid-----------------------------------------------------------
source(file.path(examples_dir, "maxima_grid.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-orderfast-------------------------------------------------------------
source(file.path(examples_dir, "orderfast.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-start-finder----------------------------------------------------------
source(file.path(examples_dir, "start_finder.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----ex-transform-df----------------------------------------------------------
source(file.path(examples_dir, "transform_df.R"), echo = TRUE, print.eval = TRUE, max.deparse.length = Inf)

## ----eval=FALSE---------------------------------------------------------------
# help(package = "cgmguru")

## ----eval=FALSE---------------------------------------------------------------
# browseVignettes("cgmguru")

