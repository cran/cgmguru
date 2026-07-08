## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4,
  message = FALSE,
  warning = FALSE
)

library(cgmguru)

iglu_available <- requireNamespace("iglu", quietly = TRUE)
ggplot2_available <- requireNamespace("ggplot2", quietly = TRUE)

## ----load-data, eval = iglu_available-----------------------------------------
data(example_data_5_subject, package = "iglu")
data(example_data_hall, package = "iglu")

cgm_data <- orderfast(example_data_5_subject)

data.frame(
  rows = nrow(cgm_data),
  subjects = length(unique(cgm_data$id)),
  first_time = min(cgm_data$time),
  last_time = max(cgm_data$time),
  min_glucose = min(cgm_data$gl, na.rm = TRUE),
  max_glucose = max(cgm_data$gl, na.rm = TRUE)
)

## ----missing-iglu, eval = !iglu_available-------------------------------------
# cat("The 'iglu' package is not available, so example-data chunks are skipped.\n")

## ----sensor-wear, eval = iglu_available---------------------------------------
sensor_wear(cgm_data, reading_minutes = 5)

sensor_wear(cgm_data, ndays = 14, reading_minutes = 5)

## ----all-events, eval = iglu_available----------------------------------------
all_events <- detect_all_events(
  cgm_data,
  reading_minutes = 5,
  sensor_wear_ndays = 14
)

names(all_events)
head(all_events$subject_summary)
head(all_events$glycemic_event_summary)

## ----all-events-preprocessed, eval = iglu_available---------------------------
all_events_preprocessed <- detect_all_events(
  cgm_data,
  reading_minutes = 5,
  summary_metrics_source = "preprocessed"
)

head(all_events_preprocessed$subject_summary)

## ----interpolated-grid, eval = iglu_available---------------------------------
all_events_with_grid <- detect_all_events(
  cgm_data,
  reading_minutes = 5,
  return_interpolated = TRUE
)

names(all_events_with_grid)
head(all_events_with_grid$interpolated_data)

## ----interpolate-helper, eval = iglu_available--------------------------------
event_grid <- interpolate_cgm(cgm_data, reading_minutes = 5)
head(event_grid)

## ----standalone-events, eval = iglu_available---------------------------------
hyper_lv1 <- detect_hyperglycemic_events(
  cgm_data,
  type = "lv1",
  reading_minutes = 5,
  return_interpolated = FALSE
)

hypo_lv1 <- detect_hypoglycemic_events(
  cgm_data,
  type = "lv1",
  reading_minutes = 5,
  return_interpolated = FALSE
)

hyper_lv1$events_total
hypo_lv1$events_total
head(hyper_lv1$events_detailed)

## ----event-summary-nonzero, eval = iglu_available-----------------------------
nonzero_events <- all_events$glycemic_event_summary[
  all_events$glycemic_event_summary$total_episodes > 0,
]
head(nonzero_events)

## ----grid-analysis, eval = iglu_available-------------------------------------
grid_result <- grid(cgm_data, gap = 15, threshold = 130)

grid_result$episode_counts
head(grid_result$episode_start)
head(grid_result$grid_vector)

## ----grid-sensitive, eval = iglu_available------------------------------------
sensitive_grid <- grid(cgm_data, gap = 10, threshold = 120)
head(sensitive_grid$episode_counts)

## ----maxima-grid, eval = iglu_available---------------------------------------
maxima_result <- maxima_grid(
  cgm_data,
  threshold = 130,
  gap = 60,
  hours = 2
)

maxima_result$episode_counts
head(maxima_result$results)

## ----postprandial-pipeline, eval = iglu_available-----------------------------
grid_starts <- start_finder(grid_result$grid_vector)

mod_grid_result <- mod_grid(
  cgm_data,
  grid_starts,
  hours = 2,
  gap = 60
)

mod_grid_starts <- start_finder(mod_grid_result$mod_grid_vector)

max_after_result <- find_max_after_hours(
  cgm_data,
  mod_grid_starts,
  hours = 2
)

local_maxima <- find_local_maxima(cgm_data)

new_maxima <- find_new_maxima(
  cgm_data,
  max_after_result$max_index,
  local_maxima$local_maxima_vector
)

mapped_maxima <- transform_df(grid_result$episode_start, new_maxima)
between_maxima <- detect_between_maxima(cgm_data, mapped_maxima)

head(mapped_maxima)
head(between_maxima$results)

## ----excursion, eval = iglu_available-----------------------------------------
excursion_result <- excursion(cgm_data, gap = 15)

excursion_result$episode_counts
head(excursion_result$episode_start)

## ----plot-grid, eval = iglu_available && ggplot2_available--------------------
subject_id <- unique(cgm_data$id)[1]
subject_data <- cgm_data[cgm_data$id == subject_id, ]
subject_grid_starts <- grid_result$episode_start[
  grid_result$episode_start$id == subject_id,
]

ggplot2::ggplot(subject_data, ggplot2::aes(x = time, y = gl)) +
  ggplot2::geom_line(linewidth = 0.3, color = "steelblue") +
  ggplot2::geom_hline(yintercept = c(54, 70), linetype = "dashed",
                      color = "darkorange") +
  ggplot2::geom_hline(yintercept = c(180, 250), linetype = "dashed",
                      color = "firebrick") +
  ggplot2::geom_point(
    data = subject_grid_starts,
    ggplot2::aes(x = time, y = gl),
    color = "black",
    size = 1.4
  ) +
  ggplot2::labs(
    title = paste("CGM Trace and GRID Starts:", subject_id),
    x = "Time",
    y = "Glucose (mg/dL)"
  ) +
  ggplot2::theme_minimal()

## ----plot-grid-missing, eval = iglu_available && !ggplot2_available-----------
# cat("The 'ggplot2' package is not available, so the plot is skipped.\n")

## ----larger-data, eval = iglu_available---------------------------------------
hall_data <- orderfast(example_data_hall)

hall_summary <- detect_all_events(hall_data, reading_minutes = 5)
hall_grid <- grid(hall_data, gap = 15, threshold = 130)

data.frame(
  subjects = length(unique(hall_data$id)),
  rows = nrow(hall_data),
  summary_rows = nrow(hall_summary$subject_summary),
  grid_rows = nrow(hall_grid$grid_vector)
)

## ----browse-vignettes, eval = FALSE-------------------------------------------
# browseVignettes("cgmguru")
# vignette("intro", package = "cgmguru")
# vignette("detect_all_events", package = "cgmguru")
# vignette("grid", package = "cgmguru")
# vignette("maxima_grid", package = "cgmguru")

