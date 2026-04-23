rlang::check_installed("shiny", version = "1.8.1")
rlang::check_installed("bslib", version = "0.8.0.9000")
rlang::check_installed("future")
rlang::check_installed("ggplot2")
rlang::check_installed("markdown")

library(shiny)
library(bslib)
library(ggplot2)

library(future)
plan(multisession)

options(
  bslib.color_contrast_warnings = FALSE
  # shiny.autoreload.pattern = "_brand[.]yml|app[.]R|[.]s?css" ## TODO: Enable after fixing autoreload
)

if (!file.exists("Monda.ttf")) {
  download.file(
    "https://github.com/google/fonts/raw/48db77e32954f6f5e65a7122ecbe8a2093c4f5d7/ofl/monda/Monda%5Bwght%5D.ttf",
    "Monda.ttf"
  )
  download.file(
    "https://github.com/google/fonts/raw/48db77e32954f6f5e65a7122ecbe8a2093c4f5d7/ofl/monda/OFL.txt",
    "Monda-OFL.txt"
  )
}

theme_brand <- bs_theme(brand = TRUE)

brand <- attr(theme_brand, "brand")

theme_set(theme_minimal())

if (requireNamespace("thematic", quietly = TRUE)) {
  if (!is.null(brand)) {
    # TODO: Update plot fonts dynamically
    thematic::thematic_shiny(
      font = bslib:::brand_pluck(brand, "typography", "base", "family")
    )
  } else {
    thematic::thematic_shiny()
  }
}

is_app_hosted <-
  Sys.getenv("R_CONFIG_ACTIVE") %in%
  c("shinylive", "shinyapps", "rsconnect", "rstudio_cloud")
is_app_packaged <-
  getwd() != system.file("examples-shiny/brand.yml", package = "bslib")

# ==============================================================================
# CARS-2-HF (Childhood Autism Rating Scale, 2nd Edition - High-Functioning)
# R Shiny Application for Clinical Administration and Scoring
# ==============================================================================
# Based on: Schopler, Van Bourgondien, Wellman, & Love (2010)
# For use with verbally fluent individuals aged 6+ with IQ >= 80
# ==============================================================================

# Load required packages
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(rmarkdown)
library(ggplot2)
library(bslib)

# Source data and utility files
source("cars2_hf_data.R")
source("utils.R")

# ==============================================================================
# UI DEFINITION
# ==============================================================================

ui <- fluidPage(
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML(
      "
      .app-header {
        background-color: #2c3e50;
        color: white;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 5px;
      }
      .app-header h1 { margin-top: 0; }
      .app-header p { margin-bottom: 0; opacity: 0.9; }
      
    .col-sm-2 {
      position: sticky;
      top: 20px;
      align-self: flex-start;
      max-height: calc(100vh - 40px);
      overflow-y: auto;
    }
    
    .well {
      position: sticky;
      top: 20px;
    }
    
    #main_nav .nav.nav-pills {
      position: sticky;
      top: 20px;
      max-height: calc(100vh - 40px);
      overflow-y: auto;
    }
    
    .item-panel {
      background-color: #f8f9fa;
      padding: 15px;
      border-radius: 5px;
      margin-bottom: 15px;
      border-left: 4px solid #3498db;
    }
      
      .item-panel {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 15px;
        border-left: 4px solid #3498db;
      }
      .item-title {
        font-weight: bold;
        color: #2c3e50;
        font-size: 1.1em;
        margin-bottom: 10px;
      }
      .definition-text {
        font-style: italic;
        color: #555;
        margin-bottom: 10px;
      }
      .considerations-text {
        background-color: #fff3cd;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 10px;
      }
      .scoring-panel {
        background-color: #e9ecef;
        padding: 10px;
        border-radius: 5px;
      }
      .score-summary {
        background-color: #d4edda;
        padding: 15px;
        border-radius: 5px;
        margin-top: 15px;
      }
      .score-severe {
        background-color: #f8d7da;
      }
      .score-moderate {
        background-color: #fff3cd;
      }
      .score-minimal {
        background-color: #d4edda;
      }
      .rating-choice {
        margin: 5px 0;
        padding: 8px;
        border-radius: 5px;
        cursor: pointer;
      }
      .rating-choice:hover {
        background-color: #e9ecef;
      }
      .observations-input {
        margin-top: 10px;
      }
      .nav-pills > li > a {
        color: #2c3e50;
      }
      #main_nav .nav.nav-pills {
        position: sticky;
        top: 20px;
        max-height: calc(100vh - 40px);
        overflow-y: auto;
      }
      .scroll-top-row {
        margin-top: 10px;
        text-align: right;
      }
    "
    ))
  ),
  tags$script(HTML(
    "
    $(document).on('shiny:connected', function() {
      // Scroll to top when navigation item is clicked
      $('#main_nav a').on('click', function() {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      });
    });
  "
  )),
  tags$script(HTML(
    "
    function scrollToTop() {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    $(document).on('click', '#scroll_top_items_1_5', function() { scrollToTop(); });
    $(document).on('click', '#scroll_top_items_6_10', function() { scrollToTop(); });
    $(document).on('click', '#scroll_top_items_11_15', function() { scrollToTop(); });
  "
  )),

  # App Header
  div(
    class = "app-header",
    h1("CARS-2-HF Rating Scale"),
    p(
      "Childhood Autism Rating Scale, Second Edition - High-Functioning Version"
    ),
    p("For verbally fluent individuals aged 6+ with IQ ≥ 80")
  ),

  # Main Navigation
  navlistPanel(
    id = "main_nav",
    widths = c(2, 10),
    well = TRUE,

    # -------------------------------------------------------------------------
    # Demographics Tab
    # -------------------------------------------------------------------------
    tabPanel(
      "Demographics",
      icon = icon("user"),

      h3("Individual Information"),

      fluidRow(
        column(
          6,
          textInput("demo_name", "Name *", width = "100%"),
          textInput("demo_case_id", "Case ID Number", width = "100%"),
          dateInput(
            "demo_test_date",
            "Test Date *",
            value = Sys.Date(),
            width = "100%"
          ),
          dateInput("demo_dob", "Date of Birth *", value = NULL, width = "100%")
        ),
        column(
          6,
          numericInput(
            "demo_age_years",
            "Age (Years)",
            value = NA,
            min = 6,
            max = 99,
            width = "100%"
          ),
          numericInput(
            "demo_age_months",
            "Age (Months)",
            value = NA,
            min = 0,
            max = 11,
            width = "100%"
          ),
          selectInput(
            "demo_gender",
            "Gender",
            choices = c(
              "",
              "Male",
              "Female",
              "Non-binary",
              "Other",
              "Prefer not to say"
            ),
            width = "100%"
          ),
          selectInput(
            "demo_ethnic",
            "Race/Ethnicity *",
            choices = c(
              "",
              "White/Caucasian (non-hispanic)",
              "Black/African American",
              "Asian",
              "Hispanic/Latino",
              "Middle Eastern",
              "Native American/Pacific Islander",
              "Other:"
            ),
            width = "100%"
          ),
          conditionalPanel(
            condition = "input.demo_ethnic == 'Other:'",
            textInput("demo_ethnic_other", "Please specify", width = "100%")
          )
        )
      ),

      h4("Rater Information"),

      fluidRow(
        column(6, textInput("demo_rater", "Rater's Name *", width = "100%")),
        column(
          6,
          textInput(
            "demo_info_sources",
            "Based on Information From",
            placeholder = "e.g., Direct observation, Parent report, Teacher report",
            width = "100%"
          )
        )
      ),

      hr(),

      div(
        class = "well",
        h4("CARS2-HF Eligibility Criteria"),
        tags$ul(
          tags$li(
            strong("Age:"),
            " Individual must be 6 years of age or older"
          ),
          tags$li(strong("IQ:"), " Estimated overall IQ of 80 or higher"),
          tags$li(
            strong("Communication:"),
            " Verbally fluent (can engage in conversation)"
          ),
          tags$li(
            strong("Information Sources:"),
            " Requires information from multiple sources including direct observation and informant reports"
          )
        ),
        p(
          class = "text-muted",
          "If the individual does not meet these criteria, use the CARS2-ST (Standard Version) instead."
        )
      )
    ),

    # -------------------------------------------------------------------------
    # Rating Items 1-5
    # -------------------------------------------------------------------------
    tabPanel(
      "Items 1-5",
      icon = icon("list-check"),

      h3("Rating Items 1-5: Social Cognition & Behavior"),

      # Generate UI for items 1-5
      lapply(1:5, function(i) {
        item_key <- sprintf("item_%02d", i)
        item <- cars2_hf_items[[item_key]]

        div(
          class = "item-panel",
          div(
            class = "item-title",
            paste0("Item ", item$number, ": ", item$name),
            tags$span(class = "badge bg-info", item$domain)
          ),

          p(class = "definition-text", item$definition),

          if (!is.null(item$considerations)) {
            div(
              class = "considerations-text",
              strong("Considerations: "),
              item$considerations
            )
          },

          div(
            class = "scoring-panel",
            h5("Rating:"),
            radioButtons(
              inputId = paste0("rating_", item_key),
              label = NULL,
              choices = setNames(
                c(NA, 1, 1.5, 2, 2.5, 3, 3.5, 4),
                c(
                  "Not Rated",
                  paste0("1 - ", item$scoring[["1"]]),
                  "1.5 - Between 1 and 2",
                  paste0("2 - ", item$scoring[["2"]]),
                  "2.5 - Between 2 and 3",
                  paste0("3 - ", item$scoring[["3"]]),
                  "3.5 - Between 3 and 4",
                  paste0("4 - ", item$scoring[["4"]])
                )
              ),
              selected = NA,
              width = "100%"
            )
          ),

          div(
            class = "observations-input",
            textAreaInput(
              paste0("obs_", item_key),
              "Observations/Notes:",
              rows = 2,
              width = "100%",
              placeholder = "Record behavioral observations and information sources..."
            )
          )
        )
      }),
      div(
        class = "scroll-top-row",
        actionButton(
          "scroll_top_items_1_5",
          "Back to top",
          class = "btn btn-secondary btn-sm"
        )
      )
    ),

    # -------------------------------------------------------------------------
    # Rating Items 6-10
    # -------------------------------------------------------------------------
    tabPanel(
      "Items 6-10",
      icon = icon("list-check"),

      h3("Rating Items 6-10: Sensory & Emotional Response"),

      lapply(6:10, function(i) {
        item_key <- sprintf("item_%02d", i)
        item <- cars2_hf_items[[item_key]]

        div(
          class = "item-panel",
          div(
            class = "item-title",
            paste0("Item ", item$number, ": ", item$name),
            tags$span(class = "badge bg-info", item$domain)
          ),

          p(class = "definition-text", item$definition),

          if (!is.null(item$considerations)) {
            div(
              class = "considerations-text",
              strong("Considerations: "),
              item$considerations
            )
          },

          div(
            class = "scoring-panel",
            h5("Rating:"),
            radioButtons(
              inputId = paste0("rating_", item_key),
              label = NULL,
              choices = setNames(
                c(NA, 1, 1.5, 2, 2.5, 3, 3.5, 4),
                c(
                  "Not Rated",
                  paste0("1 - ", item$scoring[["1"]]),
                  "1.5 - Between 1 and 2",
                  paste0("2 - ", item$scoring[["2"]]),
                  "2.5 - Between 2 and 3",
                  paste0("3 - ", item$scoring[["3"]]),
                  "3.5 - Between 3 and 4",
                  paste0("4 - ", item$scoring[["4"]])
                )
              ),
              selected = NA,
              width = "100%"
            )
          ),

          div(
            class = "observations-input",
            textAreaInput(
              paste0("obs_", item_key),
              "Observations/Notes:",
              rows = 2,
              width = "100%",
              placeholder = "Record behavioral observations and information sources..."
            )
          )
        )
      }),
      div(
        class = "scroll-top-row",
        actionButton(
          "scroll_top_items_6_10",
          "Back to top",
          class = "btn btn-secondary btn-sm"
        )
      )
    ),

    # -------------------------------------------------------------------------
    # Rating Items 11-15
    # -------------------------------------------------------------------------
    tabPanel(
      "Items 11-15",
      icon = icon("list-check"),

      h3("Rating Items 11-15: Communication & Cognitive"),

      lapply(11:15, function(i) {
        item_key <- sprintf("item_%02d", i)
        item <- cars2_hf_items[[item_key]]

        div(
          class = "item-panel",
          div(
            class = "item-title",
            paste0("Item ", item$number, ": ", item$name),
            tags$span(class = "badge bg-info", item$domain)
          ),

          p(class = "definition-text", item$definition),

          if (!is.null(item$considerations)) {
            div(
              class = "considerations-text",
              strong("Considerations: "),
              item$considerations
            )
          },

          div(
            class = "scoring-panel",
            h5("Rating:"),
            radioButtons(
              inputId = paste0("rating_", item_key),
              label = NULL,
              choices = setNames(
                c(NA, 1, 1.5, 2, 2.5, 3, 3.5, 4),
                c(
                  "Not Rated",
                  paste0("1 - ", item$scoring[["1"]]),
                  "1.5 - Between 1 and 2",
                  paste0("2 - ", item$scoring[["2"]]),
                  "2.5 - Between 2 and 3",
                  paste0("3 - ", item$scoring[["3"]]),
                  "3.5 - Between 3 and 4",
                  paste0("4 - ", item$scoring[["4"]])
                )
              ),
              selected = NA,
              width = "100%"
            )
          ),

          div(
            class = "observations-input",
            textAreaInput(
              paste0("obs_", item_key),
              "Observations/Notes:",
              rows = 2,
              width = "100%",
              placeholder = "Record behavioral observations and information sources..."
            )
          )
        )
      }),
      div(
        class = "scroll-top-row",
        actionButton(
          "scroll_top_items_11_15",
          "Back to top",
          class = "btn btn-secondary btn-sm"
        )
      )
    ),

    # -------------------------------------------------------------------------
    # Summary & Scoring Tab
    # -------------------------------------------------------------------------
    tabPanel(
      "Summary",
      icon = icon("chart-bar"),

      h3("CARS2-HF Summary"),

      fluidRow(
        column(
          6,
          h4("Individual Information"),
          verbatimTextOutput("summary_demographics")
        ),
        column(
          6,
          h4("Scoring Summary"),
          uiOutput("summary_scores")
        )
      ),

      hr(),

      h4("Item Ratings Overview"),
      tableOutput("ratings_table"),

      hr(),

      h4("Profile Plot"),
      plotOutput("profile_plot", height = "400px"),

      hr(),

      h4("Interpretation"),
      uiOutput("interpretation_text"),

      div(
        class = "well",
        h5("Important Notes:"),
        tags$ul(
          tags$li("The CARS2-HF is not a diagnostic instrument by itself."),
          tags$li(
            "Results should be integrated with comprehensive evaluation data."
          ),
          tags$li(
            "Clinical judgment should always be exercised when interpreting results."
          ),
          tags$li(
            "Early developmental history supportive of autism is essential for diagnosis."
          )
        )
      )
    ),

    # -------------------------------------------------------------------------
    # Export Tab
    # -------------------------------------------------------------------------
    tabPanel(
      "Export",
      icon = icon("download"),

      h3("Export Results"),

      fluidRow(
        column(
          6,
          h4("Download Options"),

          selectInput(
            "report_format",
            "Report Format",
            choices = c("PDF" = "pdf", "Word" = "docx", "HTML" = "html"),
            width = "100%"
          ),

          checkboxGroupInput(
            "report_sections",
            "Include Sections:",
            choices = c(
              "Demographics" = "demographics",
              "Item Ratings" = "ratings",
              "Scoring Summary" = "scoring",
              "Interpretation" = "interpretation",
              "Observations" = "observations"
            ),
            selected = c(
              "demographics",
              "ratings",
              "scoring",
              "interpretation"
            ),
            width = "100%"
          ),

          downloadButton(
            "download_report",
            "Download Report",
            class = "btn-primary btn-lg"
          ),

          br(),
          br(),

          downloadButton(
            "download_csv",
            "Download Raw Data (CSV)",
            class = "btn-secondary"
          )
        ),
        column(
          6,
          h4("Validation Status"),
          uiOutput("validation_status")
        )
      )
    )
  )
)

# ==============================================================================
# SERVER DEFINITION
# ==============================================================================

server <- function(input, output, session) {
  # ---------------------------------------------------------------------------
  # Reactive: Collect all ratings
  # ---------------------------------------------------------------------------
  ratings <- reactive({
    rating_list <- list()
    for (i in 1:15) {
      item_key <- sprintf("item_%02d", i)
      rating_input <- input[[paste0("rating_", item_key)]]
      rating_list[[item_key]] <- if (
        is.null(rating_input) || rating_input == "NA" || is.na(rating_input)
      ) {
        NA
      } else {
        as.numeric(rating_input)
      }
    }
    rating_list
  })

  # ---------------------------------------------------------------------------
  # Reactive: Collect all observations
  # ---------------------------------------------------------------------------
  observations <- reactive({
    obs_list <- list()
    for (i in 1:15) {
      item_key <- sprintf("item_%02d", i)
      obs_list[[item_key]] <- input[[paste0("obs_", item_key)]]
    }
    obs_list
  })

  # ---------------------------------------------------------------------------
  # Reactive: Calculate scores
  # ---------------------------------------------------------------------------
  scores <- reactive({
    r <- ratings()
    total_raw <- calculate_total_raw_score(r)

    list(
      total_raw = total_raw,
      tscore = raw_to_tscore(total_raw),
      percentile = raw_to_percentile(total_raw),
      severity = get_severity_category(total_raw),
      n_rated = sum(!is.na(unlist(r)))
    )
  })

  # ---------------------------------------------------------------------------
  # Auto-calculate age
  # ---------------------------------------------------------------------------
  observe({
    dob <- input$demo_dob
    today <- Sys.Date()

    if (!is.null(dob) && !is.null(today)) {
      age <- calculate_age(dob, today)

      if (!is.na(age$years)) {
        updateNumericInput(session, "demo_age_years", value = age$years)
        updateNumericInput(session, "demo_age_months", value = age$months)
      }
    }
  })

  # ---------------------------------------------------------------------------
  # Summary: Demographics Output
  # ---------------------------------------------------------------------------
  output$summary_demographics <- renderText({
    ethnic_display <- input$demo_ethnic %||% "Not provided"
    if (
      ethnic_display == "Other:" &&
        !(is.null(input$demo_ethnic_other) || input$demo_ethnic_other == "")
    ) {
      ethnic_display <- input$demo_ethnic_other
    }
    paste0(
      "Name: ",
      input$demo_name %||% "Not provided",
      "\n",
      "Case ID: ",
      input$demo_case_id %||% "Not provided",
      "\n",
      "Test Date: ",
      format_date(input$demo_test_date),
      "\n",
      "Date of Birth: ",
      format_date(input$demo_dob),
      "\n",
      "Age: ",
      input$demo_age_years %||% "?",
      " years, ",
      input$demo_age_months %||% "?",
      " months\n",
      "Gender: ",
      input$demo_gender %||% "Not provided",
      "\n",
      "Race/Ethnicity: ",
      ethnic_display,
      "\n",
      "Rater: ",
      input$demo_rater %||% "Not provided",
      "\n",
      "Information Sources: ",
      input$demo_info_sources %||% "Not specified"
    )
  })

  # ---------------------------------------------------------------------------
  # Summary: Scores Output
  # ---------------------------------------------------------------------------
  output$summary_scores <- renderUI({
    s <- scores()

    severity_class <- switch(
      s$severity,
      "Minimal-to-No Symptoms" = "score-minimal",
      "Mild-to-Moderate Symptoms" = "score-moderate",
      "Severe Symptoms" = "score-severe",
      ""
    )

    div(
      class = paste("score-summary", severity_class),
      h4(
        "Total Raw Score: ",
        if (is.na(s$total_raw)) "Incomplete" else s$total_raw
      ),
      p(strong("T-Score: "), if (is.na(s$tscore)) "N/A" else s$tscore),
      p(
        strong("Percentile: "),
        if (is.na(s$percentile)) "N/A" else paste0(s$percentile, "th")
      ),
      p(strong("Severity Category: "), s$severity),
      p(class = "text-muted", paste("Items Rated:", s$n_rated, "of 15"))
    )
  })

  # ---------------------------------------------------------------------------
  # Summary: Ratings Table
  # ---------------------------------------------------------------------------
  output$ratings_table <- renderTable(
    {
      r <- ratings()

      data.frame(
        Item = 1:15,
        Name = sapply(1:15, function(i) {
          cars2_hf_items[[sprintf("item_%02d", i)]]$name
        }),
        Domain = sapply(1:15, function(i) {
          cars2_hf_items[[sprintf("item_%02d", i)]]$domain
        }),
        Rating = sapply(1:15, function(i) {
          val <- r[[sprintf("item_%02d", i)]]
          if (is.na(val)) "Not Rated" else as.character(val)
        }),
        Median = sapply(1:15, function(i) {
          cars2_hf_items[[sprintf("item_%02d", i)]]$median
        })
      )
    },
    striped = TRUE,
    hover = TRUE
  )

  # ---------------------------------------------------------------------------
  # Summary: Profile Plot
  # ---------------------------------------------------------------------------
  output$profile_plot <- renderPlot({
    r <- ratings()

    plot_data <- create_profile_data(r, cars2_hf_items)

    ggplot(plot_data, aes(x = factor(item_number), y = rating)) +
      geom_bar(stat = "identity", fill = "#3498db", alpha = 0.7) +
      geom_point(aes(y = median), color = "red", size = 3, shape = 18) +
      geom_hline(yintercept = c(2, 3), linetype = "dashed", color = "gray50") +
      scale_y_continuous(limits = c(0, 4), breaks = 1:4) +
      labs(
        x = "Item Number",
        y = "Rating",
        title = "CARS2-HF Item Profile",
        subtitle = "Blue bars = Individual ratings, Red diamonds = Normative medians"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 0),
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5)
      )
  })

  # ---------------------------------------------------------------------------
  # Summary: Interpretation
  # ---------------------------------------------------------------------------
  output$interpretation_text <- renderUI({
    s <- scores()

    interpretation <- generate_interpretation(
      s$total_raw,
      s$tscore,
      s$percentile
    )

    div(
      class = "well",
      p(interpretation)
    )
  })

  # ---------------------------------------------------------------------------
  # Export: Validation Status
  # ---------------------------------------------------------------------------
  output$validation_status <- renderUI({
    r <- ratings()
    missing <- validate_ratings(r)

    if (length(missing) == 0) {
      div(
        class = "alert alert-success",
        icon("check-circle"),
        " All 15 items have been rated. Ready to export."
      )
    } else {
      div(
        class = "alert alert-warning",
        icon("exclamation-triangle"),
        paste(" Missing ratings for:", paste(missing, collapse = ", "))
      )
    }
  })

  # ---------------------------------------------------------------------------
  # Export: Download Report
  # ---------------------------------------------------------------------------
  output$download_report <- downloadHandler(
    filename = function() {
      ext <- switch(
        input$report_format,
        "pdf" = "pdf",
        "docx" = "docx",
        "html" = "html"
      )
      paste0(
        "CARS2-HF_Report_",
        input$demo_name,
        "_",
        format(Sys.Date(), "%Y%m%d"),
        ".",
        ext
      )
    },
    content = function(file) {
      # Create temporary Rmd file
      tempReport <- file.path(tempdir(), "report.Rmd")

      s <- scores()
      r <- ratings()
      obs <- observations()

      # Build report content
      report_lines <- c(
        "---",
        "title: 'CARS-2-HF Assessment Report'",
        paste0("author: '", input$demo_rater, "'"),
        paste0("date: '", format(Sys.Date(), "%B %d, %Y"), "'"),
        paste0(
          "output: ",
          switch(
            input$report_format,
            "pdf" = "pdf_document",
            "docx" = "word_document",
            "html" = "html_document"
          )
        ),
        "---",
        ""
      )

      if ("demographics" %in% input$report_sections) {
        ethnic_display <- input$demo_ethnic
        if (
          ethnic_display == "Other:" &&
            !(is.null(input$demo_ethnic_other) || input$demo_ethnic_other == "")
        ) {
          ethnic_display <- input$demo_ethnic_other
        }
        report_lines <- c(
          report_lines,
          "# Individual Information",
          "",
          paste0("**Name:** ", input$demo_name),
          "",
          paste0("**Case ID:** ", input$demo_case_id),
          "",
          paste0("**Test Date:** ", format_date(input$demo_test_date)),
          "",
          paste0("**Date of Birth:** ", format_date(input$demo_dob)),
          "",
          paste0(
            "**Age:** ",
            input$demo_age_years,
            " years, ",
            input$demo_age_months,
            " months"
          ),
          "",
          paste0("**Gender:** ", input$demo_gender),
          "",
          paste0("**Race/Ethnicity:** ", ethnic_display),
          "",
          paste0("**Rater:** ", input$demo_rater),
          "",
          paste0("**Information Sources:** ", input$demo_info_sources),
          ""
        )
      }

      if ("ratings" %in% input$report_sections) {
        report_lines <- c(report_lines, "# Item Ratings", "")

        for (i in 1:15) {
          item_key <- sprintf("item_%02d", i)
          item <- cars2_hf_items[[item_key]]
          rating <- r[[item_key]]
          rating_text <- if (is.na(rating)) {
            "Not Rated"
          } else {
            as.character(rating)
          }

          report_lines <- c(
            report_lines,
            paste0("**Item ", i, " - ", item$name, ":** ", rating_text),
            ""
          )
        }
      }

      if ("scoring" %in% input$report_sections) {
        report_lines <- c(
          report_lines,
          "# Scoring Summary",
          "",
          paste0(
            "**Total Raw Score:** ",
            if (is.na(s$total_raw)) "Incomplete" else s$total_raw
          ),
          "",
          paste0("**T-Score:** ", if (is.na(s$tscore)) "N/A" else s$tscore),
          "",
          paste0(
            "**Percentile:** ",
            if (is.na(s$percentile)) "N/A" else paste0(s$percentile, "th")
          ),
          "",
          paste0("**Severity Category:** ", s$severity),
          ""
        )
      }

      if ("interpretation" %in% input$report_sections) {
        report_lines <- c(
          report_lines,
          "# Interpretation",
          "",
          generate_interpretation(s$total_raw, s$tscore, s$percentile),
          ""
        )
      }

      if ("observations" %in% input$report_sections) {
        report_lines <- c(report_lines, "# Clinical Observations", "")

        for (i in 1:15) {
          item_key <- sprintf("item_%02d", i)
          item <- cars2_hf_items[[item_key]]
          observation <- obs[[item_key]]

          if (!is.null(observation) && observation != "") {
            report_lines <- c(
              report_lines,
              paste0("**Item ", i, " - ", item$name, ":**"),
              "",
              observation,
              ""
            )
          }
        }
      }

      writeLines(report_lines, tempReport)

      rmarkdown::render(
        tempReport,
        output_file = file,
        envir = new.env(parent = globalenv())
      )
    }
  )

  # ---------------------------------------------------------------------------
  # Export: Download CSV
  # ---------------------------------------------------------------------------
  output$download_csv <- downloadHandler(
    filename = function() {
      paste0(
        "CARS2-HF_Data_",
        input$demo_name,
        "_",
        format(Sys.Date(), "%Y%m%d"),
        ".csv"
      )
    },
    content = function(file) {
      ethnic_display <- input$demo_ethnic
      if (
        ethnic_display == "Other:" &&
          !(is.null(input$demo_ethnic_other) || input$demo_ethnic_other == "")
      ) {
        ethnic_display <- input$demo_ethnic_other
      }
      demographics <- list(
        name = input$demo_name,
        case_id = input$demo_case_id,
        test_date = input$demo_test_date,
        dob = input$demo_dob,
        age_years = input$demo_age_years,
        age_months = input$demo_age_months,
        gender = input$demo_gender,
        race_ethnicity = ethnic_display,
        rater_name = input$demo_rater
      )

      export_to_csv(demographics, ratings(), cars2_hf_items, file)
    }
  )
}

# ==============================================================================
# RUN APP
# ==============================================================================

shinyApp(ui = ui, server = server)

# ui <- page_navbar(
#   theme = bs_add_rules(theme_brand, sass::sass_file("_colors.scss")),
#   title = "brand.yml Demo",
#   fillable = TRUE,

#   sidebar = sidebar(
#     id = "sidebar_editor",
#     position = "right",
#     open = "closed",
#     width = "40%",
#     bg = "var(--bs-dark)",
#     fg = "var(--bs-light)",

#     card(
#       card_header(
#         class = "text-bg-secondary hstack",
#         div("Edit", code("brand.yml")),
#         div(
#           class = "ms-auto",
#           tooltip(
#             tags$a(
#               class = "btn btn-link p-0",
#               href = "https://posit-dev.github.io/brand-yml/brand/",
#               target = "_blank",
#               bsicons::bs_icon(
#                 "question-square-fill",
#                 title = "About brand.yml",
#                 size = "1.25rem"
#               )
#             ),
#             "About brand.yml"
#           )
#         )
#       ),
#       htmltools::tagAppendAttributes(
#         textAreaInput(
#           "txt_brand_yml",
#           label = NULL,
#           value = paste(readLines("_brand.yml", warn = FALSE), collapse = "\n"),
#           width = "100%",
#           height = "80%",
#           rows = 20
#         ),
#         class = "font-monospace",
#         .cssSelector = "textarea"
#       ),
#       card_body(
#         padding = 0,
#         div(
#           id = "editor_brand_yml",
#           style = "overflow: auto;",
#           as_fill_item()
#         )
#       )
#     ),

#     tags$script(
#       type = "module",
#       HTML(
#         '
# import { basicEditor } from "https://esm.sh/prism-code-editor@3.4.0/setups";
# import "https://esm.sh/prism-code-editor@3.4.0/prism/languages/yaml";

# const shinyInput = document.getElementById("txt_brand_yml");

# function initBrandEditor() {
#   if (typeof Shiny.setInputValue !== "function") {
#     setTimeout(initBrandEditor, 100);
#     return;
#   }
#   window.brandEditor = basicEditor(
#     "#editor_brand_yml",
#     {
#       language: "yml",
#       theme: "github-dark",
#       value: shinyInput.value,
#       onUpdate: (value) => {
#         Shiny.setInputValue("txt_brand_yml", value);
#       },
#     },
#     () => shinyInput.parentElement.parentElement.remove()
#   );
# }

# initBrandEditor();
# '
#       )
#     ),

#     tags$style(
#       HTML(
#         '
# .bslib-sidebar-layout .sidebar-title { margin-bottom: 0 }
# #sidebar_editor .sidebar-content { height: max(600px, 100%) }'
#       )
#     ),

#     if (is_app_hosted || is_app_packaged) {
#       shiny::downloadButton(
#         "download",
#         label = span("Download", code("_brand.yml"), "file"),
#         class = "btn-outline-light"
#       )
#     } else {
#       actionButton(
#         "save",
#         label = span("Save", code("_brand.yml"), "file"),
#         class = "btn-outline-light"
#       )
#     }
#   ),

#   nav_panel(
#     "Input Output Demo",
#     value = "dashboard",
#     layout_sidebar(
#       sidebar = sidebar(
#         sliderInput("slider1", "Numeric Slider Input", 0, 11, 11),
#         numericInput("numeric1", "Numeric Input Widget", 30),
#         dateInput("date1", "Date Input Component", value = "2024-01-01"),
#         input_switch("switch1", "Binary Switch Input", value = TRUE),
#         radioButtons(
#           "radio1",
#           "Radio Button Group",
#           choices = c("Option A", "Option B", "Option C", "Option D")
#         ),
#         actionButton("action1", "Action Button")
#       ),
#       shiny::useBusyIndicators(),
#       layout_column_wrap(
#         value_box(
#           title = "Metric 1",
#           value = "100",
#           theme = "primary",
#           id = "value_box_one"
#         ),
#         value_box(
#           title = "Metric 2",
#           value = "200",
#           theme = "secondary",
#           id = "value_box_two"
#         ),
#         value_box(
#           title = "Metric 3",
#           value = "300",
#           theme = "info",
#           id = "value_box_three"
#         )
#       ),
#       card(
#         card_header("Plot Output"),
#         plotOutput("out_plot")
#       ),
#       card(
#         card_header("Text Output"),
#         verbatimTextOutput("out_text")
#       )
#     )
#   ),

#   nav_panel(
#     "Widget Gallery",
#     layout_column_wrap(
#       width = 300,
#       heights_equal = "row",
#       card(
#         card_header("Button Variants"),
#         actionButton("btn_default", "Default"),
#         actionButton("btn_primary", "Primary", class = "btn-primary"),
#         actionButton("btn_secondary", "Secondary", class = "btn-secondary"),
#         actionButton("btn_success", "Success", class = "btn-success"),
#         actionButton("btn_danger", "Danger", class = "btn-danger"),
#         actionButton("btn_warning", "Warning", class = "btn-warning"),
#         actionButton("btn_info", "Info", class = "btn-info")
#       ),
#       card(
#         card_header("Radio Button Examples"),
#         radioButtons(
#           "radio2",
#           "Standard Radio Group",
#           choices = c("Selection 1", "Selection 2", "Selection 3")
#         ),
#         radioButtons(
#           "radio3",
#           "Inline Radio Group",
#           choices = c("Option 1", "Option 2", "Option 3"),
#           inline = TRUE
#         )
#       ),
#       card(
#         card_header("Checkbox Examples"),
#         checkboxGroupInput(
#           "check1",
#           "Standard Checkbox Group",
#           choices = c("Item 1", "Item 2", "Item 3")
#         ),
#         checkboxGroupInput(
#           "check2",
#           "Inline Checkbox Group",
#           choices = c("Choice A", "Choice B", "Choice C"),
#           inline = TRUE
#         )
#       ),
#       card(
#         card_header("Select Input Widgets"),
#         selectizeInput(
#           "select1",
#           "Selectize Input",
#           choices = c("Selection A", "Selection B", "Selection C")
#         ),
#         selectInput(
#           "select2",
#           "Multiple Select Input",
#           choices = c("Item X", "Item Y", "Item Z"),
#           multiple = TRUE
#         )
#       ),
#       card(
#         card_header("Text Input Widgets"),
#         textInput("text1", "Text Input"),
#         textAreaInput(
#           "textarea1",
#           "Text Area Input",
#           value = "Default text content for the text area widget"
#         ),
#         passwordInput("password1", "Password Input")
#       )
#     )
#   ),

#   nav_panel(
#     "Colors",
#     div(
#       class = "container-sm overflow-y-auto",
#       uiOutput("ui_colors")
#     )
#   ),

#   nav_panel(
#     "Documentation",
#     div(
#       class = "container-sm overflow-y-auto",
#       if (FALSE) library(markdown), # for shinyapps.io
#       includeMarkdown("documentation.md")
#     )
#   ),

#   nav_spacer(),
#   nav_item(input_dark_mode(id = "color_mode")),
#   nav_item(
#     actionLink(
#       "show_editor",
#       bsicons::bs_icon(
#         "pencil-fill",
#         size = "1rem",
#         title = "Show/hide editor"
#       ),
#       class = "nav-link"
#     )
#   ),
# )

# errors <- rlang::new_environment()

# error_notification <- function(context) {
#   function(err) {
#     time <- as.character(Sys.time())

#     msg <- conditionMessage(err)
#     # Strip ANSI color sequences from error messages
#     msg <- gsub(
#       pattern = "\u001b\\[.*?m",
#       replacement = "",
#       msg
#     )
#     # Wrap at 40 characters
#     msg <- paste(strwrap(msg, width = 60), collapse = "\n")

#     err_id <- rlang::hash(list(time, msg))
#     assign(err_id, list(message = msg, context = context), envir = errors)

#     showNotification(
#       markdown(context),
#       action = tags$button(
#         class = "btn btn-outline-danger pull-right",
#         onclick = sprintf(
#           "event.preventDefault(); Shiny.setInputValue('show_error', '%s')",
#           err_id
#         ),
#         "Show details"
#       ),
#       duration = 10,
#       type = "error",
#       id = err_id
#     )
#   }
# }

# server <- function(input, output, session) {
#   brand_yml_text <- debounce(reactive(input$txt_brand_yml), 1000)
#   brand_yml <- reactiveVal()

#   observeEvent(input$show_editor, sidebar_toggle("sidebar_editor"))

#   observeEvent(input$show_error, {
#     req(input$show_error)
#     err <- get0(input$show_error, errors)

#     if (is.null(err)) {
#       message("Could not find error with id ", input$show_error)
#       return()
#     }

#     removeNotification(input$show_error)
#     rm(list = input$show_error, envir = errors)

#     showModal(
#       modalDialog(
#         size = "l",
#         easyClose = TRUE,
#         markdown(err$context),
#         pre(err$message)
#       )
#     )
#   })

#   observeEvent(brand_yml_text(), {
#     req(brand_yml_text())

#     tryCatch(
#       {
#         b <- yaml::yaml.load(brand_yml_text())
#         b$path <- normalizePath("_brand.yml")
#         brand_yml(b)
#       },
#       error = error_notification(
#         "Could not parse `_brand.yml` file. Check for syntax errors."
#       )
#     )
#   })

#   observeEvent(brand_yml(), {
#     req(brand_yml())

#     tryCatch(
#       {
#         theme <- bs_theme(brand = brand_yml())
#         theme <- bs_add_rules(theme, sass::sass_file("_colors.scss"))
#         session$setCurrentTheme(theme)
#       },
#       error = error_notification(
#         "Could not compile branded theme. Please check your `_brand.yml` file."
#       )
#     )
#   })

#   observeEvent(input$save, {
#     validate(
#       need(input$txt_brand_yml, "_brand.yml file contents cannot be empty.")
#     )

#     tryCatch(
#       {
#         writeLines(input$txt_brand_yml, "_brand.yml")
#         showNotification(markdown("Saved `_brand.yml`!"))
#       },
#       error = error_notification("Could not save `_brand.yml`.")
#     )
#   })

#   output$download <- downloadHandler(
#     filename = "_brand.yml",
#     content = function(file) {
#       validate(
#         need(input$txt_brand_yml, "_brand.yml file contents cannot be empty.")
#       )
#       writeLines(input$txt_brand_yml, file)
#     }
#   )

#   PlotTask <- ExtendedTask$new(function(x_max, y_factor) {
#     x <- seq(0, x_max, length.out = 100)
#     y <- sin(x) * y_factor

#     future({
#       Sys.sleep(3)

#       df <- data.frame(x = x, y = y)

#       ggplot(df, aes(x = x, y = y)) +
#         geom_col(width = 1, position = "identity") +
#         labs(title = "Sine Wave Output", x = "", y = "")
#     })
#   })

#   observe({
#     x_max <- debounce(reactive(input$numeric1), 500)()
#     y_factor <- debounce(reactive(input$slider1), 500)()

#     PlotTask$invoke(x_max = x_max, y_factor = y_factor)
#   })

#   output$out_plot <- renderPlot({
#     PlotTask$result()
#   })

#   output$out_text <- renderText({
#     "example_function <- function() {\n  return(\"Function output text\")\n}"
#   })

#   output$ui_colors <- renderUI({
#     bootstrap_colors <- c(
#       "blue",
#       "indigo",
#       "purple",
#       "pink",
#       "red",
#       "orange",
#       "yellow",
#       "green",
#       "teal",
#       "cyan"
#     )
#     colors <- c("gray", bootstrap_colors)

#     tagList(
#       layout_columns(
#         col_widths = 3,
#         class = "font-monospace",
#         !!!lapply(
#           c(
#             "primary",
#             "secondary",
#             "dark",
#             "light",
#             "info",
#             "success",
#             "warning",
#             "danger"
#           ),
#           function(color) {
#             div(
#               color,
#               class = paste0("p-3 mb-2 position-relative text-bg-", color)
#             )
#           }
#         )
#       ),
#       layout_columns(
#         col_widths = 3,
#         class = "font-monospace",
#         !!!lapply(
#           c("black", "white", "foreground", "background"),
#           function(color) {
#             div(
#               color,
#               class = paste0("p-3 mb-2 position-relative bd-", color)
#             )
#           }
#         )
#       ),
#       layout_column_wrap(
#         width = 200,
#         !!!lapply(colors, function(color) {
#           if (!color %in% c("white", "black")) {
#             div(
#               class = "mb-3",
#               div(
#                 color,
#                 class = paste0("p-3 mb-2 position-relative bd-", color, "-500")
#               ),
#               lapply(seq(100, 900, 100), function(r) {
#                 div(
#                   paste0(color, "-", r),
#                   class = paste0("p-3 bd-", color, "-", r)
#                 )
#               })
#             )
#           }
#         })
#       )
#     )
#   })
# }

# shinyApp(ui, server)
