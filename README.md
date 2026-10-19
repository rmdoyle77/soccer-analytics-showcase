# ⚽ Willamette Men's Soccer Analytics Showcase

> An end-to-end sports analytics pipeline and interactive dashboard engine designed for collegiate soccer performance tracking, opponent scouting, and statistical decision support.

[![R](https://img.shields.io/badge/Language-R%204.2%2B-blue.svg?style=for-the-badge&logo=r)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Framework-R%20Shiny-blueviolet?style=for-the-badge&logo=rstudio)](https://shiny.rstudio.com/)
[![SQL](https://img.shields.io/badge/Database-SQL%20Aggregations-orange?style=for-the-badge&logo=postgresql)](#sql-analytics)
[![Impact](https://img.shields.io/badge/Standing%20Impact-6th%20to%203rd%20Place-success?style=for-the-badge)](#project-impact)


---

## 🎯 Executive Summary & Impact

In competitive collegiate athletics, bridging tactical field awareness with modern data science offers a massive competitive edge. As an **NCAA student-athlete (Goalkeeper)** pursuing a combined **B.S. in Computer Science & M.S. in Data Science**, I collaborated on building an interactive analytics database and dashboard platform for the **Willamette University Men's Soccer** program (Project Seminar with Dr. Gore).

### 🏆 Measurable Outcomes
- **Standings Elevation:** Delivered weekly opponent scouting tendencies and tactical performance trends that directly supported the coaching staff as the team climbed from **6th to 3rd place** in the Northwest Conference (NWC).
- **Goalkeeper & Defensive Optimization:** Quantified shot-stopping profiles, save percentages, and expected goal (xG) differentials to target high-danger defensive concessions.
- **Workflow Automation:** Replaced fragmented, manual post-match video notes with a reproducible data pipeline and reactive dashboard.

---

## 🏗️ System Architecture & Data Pipeline

```
┌─────────────────────────────────┐
│     Raw Match Tracking Data     │  (Shot coordinates, possession %, event tags, passes)
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│     SQL / Data Wrangling Layer   │  (PostgreSQL / dplyr: per-90 metrics, rolling form, xG deltas)
└────────────────┬────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
┌──────────────┐   ┌──────────────┐
│   R Shiny    │   │   Tableau    │  (Tactical heatmaps, shot charts, player efficiency matrix)
│  Dashboard   │   │  Scouting    │
└──────────────┘   └──────────────┘
```

---

## 🔬 Core Analytical Modules

### 1. Expected Goals (xG) & Shot Quality
- Evaluates shot likelihood and finishing efficiency by contrasting actual goals with expected goals ($xG$).
- Distinguishes between volume-heavy attacks and high-quality chances inside the central danger zone.

### 2. Goalkeeper & Shot-Stopping Profiling
- **Post-Shot Expected Goals (PSxG):** Assesses the quality of shots on target to calculate **Goals Prevented Above Expected** ($PSxG - GA$).
- **Distribution Efficiency:** Tracks distribution corridors (short build-up vs. direct aerial clearances) under opposing forward presses.

### 3. Momentum & Phase Transition Tracking
- Analyzes rolling 3-match performance metrics to detect fitness fatigue or tactical drop-offs across match halves.
- Identifies set-piece vulnerability and counter-attack concession rates.

---

## 💻 Tech Stack & Methodologies

- **Languages & Frameworks:** R (`shiny`, `ggplot2`, `dplyr`, `readr`, `bslib`), SQL
- **Visual Analytics:** Tableau, R Shiny, Markdown Reporting
- **Statistical Methods:** Rolling moving averages, Z-score standardizations, expected value modeling ($xG$), venue split variance (Home vs. Away)

---

## 🚀 Running the Interactive Demo

This repository includes a standalone interactive demonstration dashboard using synthetic sample match data.

### Prerequisites
- R (v4.0 or newer)
- R packages: `shiny`, `ggplot2`, `dplyr`, `readr`, `bslib`

### Launch the App

```bash
# 1. Clone this repository
git clone https://github.com/rmdoyle77/mens-soccer-analytics-showcase.git
cd mens-soccer-analytics-showcase

# 2. Run the Shiny app
Rscript -e "shiny::runApp('app.R')"
```

Alternatively, open `app.R` in **RStudio** and click **Run App**.

---

## 🗄️ SQL Analytics Showcase

Sample analytical SQL queries used for computing form metrics, rolling xG differentials, and defensive workload are available in:
📁 [`sql/analytics_queries.sql`](sql/analytics_queries.sql)

---

## 🔒 Data Privacy & Governance Notice

*Note: In accordance with NCAA compliance and athletic department policies, all proprietary team performance and player biometric data have been excluded. The included datasets and interactive demonstrations utilize synthetic, anonymized event figures to showcase architecture, analytical modeling, and UI design without compromising proprietary scouting strategy.*

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
