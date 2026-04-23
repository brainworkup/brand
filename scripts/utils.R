# ==============================================================================
# CARS-2-HF Utility Functions
# ==============================================================================

# Calculate age from dates
calculate_age <- function(dob, test_date) {
  if (is.null(dob) || is.null(test_date) || is.na(dob) || is.na(test_date)) {
    return(list(years = NA, months = NA))
  }

  dob <- as.Date(dob)
  test_date <- as.Date(test_date)

  if (test_date < dob) {
    return(list(years = NA, months = NA))
  }

  years <- as.integer(difftime(test_date, dob, units = "days") / 365.25)
  months_total <- as.integer(difftime(test_date, dob, units = "days") / 30.44)
  months <- months_total %% 12

  return(list(years = years, months = months))
}

# Format date for display
format_date <- function(date) {
  if (is.null(date) || is.na(date)) {
    return("")
  }
  format(as.Date(date), "%B %d, %Y")
}

# Calculate total raw score
calculate_total_raw_score <- function(ratings) {
  # ratings should be a named vector or list of numeric values
  ratings <- as.numeric(unlist(ratings))
  ratings <- ratings[!is.na(ratings)]

  if (length(ratings) == 0) {
    return(NA)
  }

  sum(ratings)
}

# Determine severity category from raw score
get_severity_category <- function(total_raw_score) {
  if (is.na(total_raw_score)) {
    return("Not Rated")
  }

  if (total_raw_score >= 15 && total_raw_score <= 27.5) {
    return("Minimal-to-No Symptoms")
  } else if (total_raw_score >= 28 && total_raw_score <= 33.5) {
    return("Mild-to-Moderate Symptoms")
  } else if (total_raw_score >= 34 && total_raw_score <= 60) {
    return("Severe Symptoms")
  } else {
    return("Out of Range")
  }
}

# Get severity category color
get_severity_color <- function(category) {
  switch(
    category,
    "Minimal-to-No Symptoms" = "#28a745",
    "Mild-to-Moderate Symptoms" = "#ffc107",
    "Severe Symptoms" = "#dc3545",
    "Not Rated" = "#6c757d",
    "#6c757d"
  )
}

# Convert raw score to T-score (approximate)
raw_to_tscore <- function(raw_score) {
  if (is.na(raw_score)) {
    return(NA)
  }

  # Based on the conversion table from the manual
  # Linear approximation for the typical range
  tscore <- round(25 + (raw_score - 15) * (76 - 25) / (60 - 15))

  # Ensure within bounds
  tscore <- max(25, min(76, tscore))

  return(tscore)
}

# Convert raw score to percentile (approximate)
raw_to_percentile <- function(raw_score) {
  if (is.na(raw_score)) {
    return(NA)
  }

  tscore <- raw_to_tscore(raw_score)

  # Standard T-score to percentile conversion
  # T = 50 + 10 * z, so z = (T - 50) / 10
  z <- (tscore - 50) / 10
  percentile <- round(pnorm(z) * 100)

  return(percentile)
}

# Get T-score category
get_tscore_category <- function(tscore) {
  if (is.na(tscore)) {
    return("Not Rated")
  }

  if (tscore < 30) {
    return("Very Low")
  } else if (tscore >= 30 && tscore < 40) {
    return("Low")
  } else if (tscore >= 40 && tscore < 60) {
    return("Average")
  } else if (tscore >= 60 && tscore < 70) {
    return("High")
  } else {
    return("Very High")
  }
}

# Get rating label from numeric value
get_rating_label <- function(value) {
  if (is.na(value) || is.null(value)) {
    return("Not Rated")
  }

  labels <- c(
    "1" = "Age-appropriate/Normal",
    "1.5" = "Very mildly abnormal",
    "2" = "Mildly abnormal",
    "2.5" = "Mildly-to-moderately abnormal",
    "3" = "Moderately abnormal",
    "3.5" = "Moderately-to-severely abnormal",
    "4" = "Severely abnormal"
  )

  key <- as.character(value)
  if (key %in% names(labels)) {
    return(labels[[key]])
  }
  return(paste0("Rating: ", value))
}

# Validate all required fields are completed
validate_ratings <- function(ratings) {
  missing <- c()

  for (i in 1:15) {
    item_key <- sprintf("item_%02d", i)
    if (is.null(ratings[[item_key]]) || is.na(ratings[[item_key]])) {
      missing <- c(missing, paste("Item", i))
    }
  }

  return(missing)
}

# Generate domain summary
get_domain_summary <- function(ratings, items_data, domains) {
  summary <- list()

  for (domain_name in names(domains)) {
    item_keys <- domains[[domain_name]]
    domain_ratings <- sapply(item_keys, function(k) {
      if (is.null(ratings[[k]])) NA else as.numeric(ratings[[k]])
    })

    domain_ratings <- domain_ratings[!is.na(domain_ratings)]

    if (length(domain_ratings) > 0) {
      summary[[domain_name]] <- list(
        mean = round(mean(domain_ratings), 2),
        n_items = length(domain_ratings),
        total = sum(domain_ratings)
      )
    }
  }

  return(summary)
}

# Generate interpretation text
generate_interpretation <- function(total_raw_score, tscore, percentile) {
  if (is.na(total_raw_score)) {
    return("No interpretation available. Please complete all 15 item ratings.")
  }

  severity <- get_severity_category(total_raw_score)

  interpretation <- paste0(
    "The individual obtained a CARS2-HF Total Raw Score of ",
    total_raw_score,
    " (T-score = ",
    tscore,
    ", ",
    percentile,
    "th percentile). "
  )

  if (severity == "Minimal-to-No Symptoms") {
    interpretation <- paste0(
      interpretation,
      "This score falls in the Minimal-to-No Symptoms range, ",
      "suggesting that symptoms of an autism spectrum disorder are minimal or absent. ",
      "Based on the CARS2-HF results alone, further comprehensive evaluation for the ",
      "presence of autism may not be warranted. However, clinical judgment and other ",
      "assessment data should always be considered."
    )
  } else if (severity == "Mild-to-Moderate Symptoms") {
    interpretation <- paste0(
      interpretation,
      "This score falls in the Mild-to-Moderate Symptoms range, ",
      "suggesting that mild-to-moderate symptoms of an autism spectrum disorder are present. ",
      "Further comprehensive evaluation for the presence of autism is warranted to determine ",
      "if diagnostic criteria are met."
    )
  } else if (severity == "Severe Symptoms") {
    interpretation <- paste0(
      interpretation,
      "This score falls in the Severe Symptoms range, ",
      "suggesting that severe symptoms of an autism spectrum disorder are present. ",
      "Further comprehensive evaluation for the presence of autism is strongly recommended ",
      "as part of the diagnostic process."
    )
  }

  return(interpretation)
}

# Generate item-level summary for report
generate_item_summary <- function(item_num, rating, item_data) {
  if (is.na(rating)) {
    return(paste0("Item ", item_num, " (", item_data$name, "): Not rated"))
  }

  label <- get_rating_label(rating)

  paste0(
    "Item ",
    item_num,
    " - ",
    item_data$name,
    ": ",
    rating,
    " (",
    label,
    ")"
  )
}

# Check if score suggests ASD
suggests_asd <- function(total_raw_score) {
  if (is.na(total_raw_score)) {
    return(NA)
  }
  return(total_raw_score >= 28)
}

# Get intervention areas based on ratings
get_intervention_areas <- function(ratings, items_data) {
  areas <- list()

  for (i in 1:15) {
    item_key <- sprintf("item_%02d", i)
    rating <- ratings[[item_key]]

    if (!is.null(rating) && !is.na(rating) && rating >= 2.5) {
      item <- items_data[[item_key]]
      areas[[item$name]] <- list(
        rating = rating,
        domain = item$domain,
        priority = if (rating >= 3.5) {
          "High"
        } else if (rating >= 3) {
          "Moderate"
        } else {
          "Low"
        }
      )
    }
  }

  # Sort by rating
  areas <- areas[order(sapply(areas, function(x) -x$rating))]

  return(areas)
}

# Create profile plot data
create_profile_data <- function(ratings, items_data) {
  data <- data.frame(
    item_number = 1:15,
    item_name = sapply(1:15, function(i) {
      items_data[[sprintf("item_%02d", i)]]$short_name
    }),
    item_label = sapply(1:15, function(i) {
      items_data[[sprintf("item_%02d", i)]]$name
    }),
    rating = sapply(1:15, function(i) {
      r <- ratings[[sprintf("item_%02d", i)]]
      if (is.null(r) || is.na(r)) NA else as.numeric(r)
    }),
    median = sapply(1:15, function(i) {
      items_data[[sprintf("item_%02d", i)]]$median
    }),
    domain = sapply(1:15, function(i) {
      items_data[[sprintf("item_%02d", i)]]$domain
    }),
    stringsAsFactors = FALSE
  )

  return(data)
}

# Export data to CSV
export_to_csv <- function(demographics, ratings, items_data, filepath) {
  # Create summary dataframe
  df <- data.frame(
    Field = character(),
    Value = character(),
    stringsAsFactors = FALSE
  )

  # Add demographics
  df <- rbind(df, data.frame(Field = "Name", Value = demographics$name %||% ""))
  df <- rbind(
    df,
    data.frame(Field = "Case ID", Value = demographics$case_id %||% "")
  )
  df <- rbind(
    df,
    data.frame(
      Field = "Test Date",
      Value = as.character(demographics$test_date)
    )
  )
  df <- rbind(
    df,
    data.frame(Field = "DOB", Value = as.character(demographics$dob))
  )
  df <- rbind(
    df,
    data.frame(
      Field = "Age",
      Value = paste(
        demographics$age_years,
        "years",
        demographics$age_months,
        "months"
      )
    )
  )
  df <- rbind(
    df,
    data.frame(Field = "Gender", Value = demographics$gender %||% "")
  )
  df <- rbind(
    df,
    data.frame(
      Field = "Race/Ethnicity",
      Value = demographics$race_ethnicity %||% ""
    )
  )
  df <- rbind(
    df,
    data.frame(Field = "Rater", Value = demographics$rater_name %||% "")
  )
  df <- rbind(df, data.frame(Field = "", Value = ""))

  # Add ratings
  for (i in 1:15) {
    item_key <- sprintf("item_%02d", i)
    item <- items_data[[item_key]]
    rating <- ratings[[item_key]]
    rating_text <- if (is.null(rating) || is.na(rating)) {
      ""
    } else {
      as.character(rating)
    }

    df <- rbind(
      df,
      data.frame(
        Field = paste0("Item ", i, ": ", item$name),
        Value = rating_text
      )
    )
  }

  # Add total score
  total <- calculate_total_raw_score(ratings)
  df <- rbind(df, data.frame(Field = "", Value = ""))
  df <- rbind(
    df,
    data.frame(Field = "Total Raw Score", Value = as.character(total))
  )
  df <- rbind(
    df,
    data.frame(
      Field = "Severity Category",
      Value = get_severity_category(total)
    )
  )
  df <- rbind(
    df,
    data.frame(Field = "T-Score", Value = as.character(raw_to_tscore(total)))
  )
  df <- rbind(
    df,
    data.frame(
      Field = "Percentile",
      Value = as.character(raw_to_percentile(total))
    )
  )

  write.csv(df, filepath, row.names = FALSE)
}

# Null coalescing operator
`%||%` <- function(a, b) if (is.null(a) || is.na(a) || a == "") b else a
