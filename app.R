# ====================================================================
# Willamette Men's Soccer Analytics: Interactive Dashboard Demo
# Technology: R Shiny, ggplot2, dplyr, readr
# Author: Ryan Doyle
# ====================================================================

library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# Load synthetic match data
data_path <- file.path("data", "match_performance_summary.csv")
if (!file.exists(data_path)) {
  data_path <- "match_performance_summary.csv"
}

matches <- tryCatch({
  read_csv(data_path, show_col_types = FALSE)
}, error = function(e) {
  # Fallback dataframe if run in isolation
  data.frame(
    match_date = as.Date('2024-09-01') + 0:7 * 7,
    opponent = c("Pacific", "Puget Sound", "Whitworth", "Whitman", "George Fox", "Linfield", "PLU", "Pacific"),
    venue = c("Home", "Away", "Home", "Away", "Home", "Away", "Home", "Away"),
    result = c("W", "W", "D", "L", "W", "W", "D", "W"),
    goals_for = c(2, 1, 1, 0, 3, 2, 0, 3),
    goals_against = c(0, 0, 1, 2, 1, 1, 0, 0),
    team_xg = c(1.85, 1.20, 1.45, 0.75, 2.40, 1.60, 0.95, 2.10),
    opponent_xg = c(0.42, 0.88, 1.32, 2.10, 0.95, 1.15, 0.80, 0.50),
    saves = c(3, 4, 5, 6, 2, 4, 5, 3),
    possession_pct = c(56.4, 49.2, 51.0, 44.8, 58.1, 52.3, 48.5, 55.0)
  )
})

# UI Definition
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly", primary = "#800000"),
  titlePanel("⚽ Willamette Men's Soccer — Match Analytics Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("📊 Filter Options"),
      selectInput("venue_filter", "Venue:", choices = c("All Venues", "Home", "Away"), selected = "All Venues"),
      selectInput("metric_choice", "Primary Trend Metric:", 
                  choices = c("Expected Goals (xG) vs Actual", "Possession %", "Saves & Defensive Workload"),
                  selected = "Expected Goals (xG) vs Actual"),
      hr(),
      p(em("Developed for Willamette University Men's Soccer analytics and performance insights."))
    ),
    
    mainPanel(
      width = 9,
      fluidRow(
        column(3, wellPanel(h5("Win Rate"), h3(textOutput("win_rate")))),
        column(3, wellPanel(h5("Avg Team xG"), h3(textOutput("avg_xg")))),
        column(3, wellPanel(h5("Clean Sheets"), h3(textOutput("clean_sheets")))),
        column(3, wellPanel(h5("Save %"), h3(textOutput("save_pct"))))
      ),
      plotOutput("trend_plot", height = "380px"),
      hr(),
      h4("📋 Match Log Summary"),
      tableOutput("match_table")
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  filtered_data <- reactive({
    df <- matches
    if (input$venue_filter != "All Venues") {
      df <- df %>% filter(venue == input$venue_filter)
    }
    df
  })
  
  output$win_rate <- renderText({
    df <- filtered_data()
    paste0(round(mean(df$result == "W") * 100, 1), "%")
  })
  
  output$avg_xg <- renderText({
    df <- filtered_data()
    sprintf("%.2f", mean(df$team_xg))
  })
  
  output$clean_sheets <- renderText({
    df <- filtered_data()
    as.character(sum(df$goals_against == 0))
  })
  
  output$save_pct <- renderText({
    df <- filtered_data()
    total_saves <- sum(df$saves)
    total_shots_faced <- total_saves + sum(df$goals_against)
    paste0(round((total_saves / max(total_shots_faced, 1)) * 100, 1), "%")
  })
  
  output$trend_plot <- renderPlot({
    df <- filtered_data()
    
    if (input$metric_choice == "Expected Goals (xG) vs Actual") {
      ggplot(df, aes(x = factor(opponent, levels = opponent))) +
        geom_col(aes(y = team_xg, fill = "Team xG"), position = "dodge", alpha = 0.7, width = 0.4) +
        geom_point(aes(y = goals_for, color = "Actual Goals"), size = 4) +
        scale_fill_manual(values = c("Team xG" = "#800000")) +
        scale_color_manual(values = c("Actual Goals" = "#2c3e50")) +
        labs(title = "Expected Goals (xG) vs. Actual Goals Scored", x = "Opponent", y = "Goals / xG", fill = "", color = "") +
        theme_minimal(base_size = 14) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    } else if (input$metric_choice == "Possession %") {
      ggplot(df, aes(x = factor(opponent, levels = opponent), y = possession_pct, group = 1)) +
        geom_line(color = "#800000", linewidth = 1.2) +
        geom_point(color = "#2c3e50", size = 3) +
        geom_hline(yintercept = 50, linetype = "dashed", color = "gray50") +
        labs(title = "Matchday Possession %", x = "Opponent", y = "Possession %") +
        theme_minimal(base_size = 14) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    } else {
      ggplot(df, aes(x = factor(opponent, levels = opponent), y = saves, fill = venue)) +
        geom_col(width = 0.5) +
        scale_fill_manual(values = c("Home" = "#800000", "Away" = "#d4af37")) +
        labs(title = "Goalkeeper Saves per Match", x = "Opponent", y = "Saves") +
        theme_minimal(base_size = 14) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  })
  
  output$match_table <- renderTable({
    filtered_data() %>% 
      select(match_date, opponent, venue, result, goals_for, goals_against, team_xg, opponent_xg, saves)
  })
}

# Run App
if (interactive()) {
  shinyApp(ui = ui, server = server)
}
