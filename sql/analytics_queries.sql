-- ====================================================================
-- Willamette Men's Soccer Analytics: Core SQL Aggregations & Pipelines
-- Author: Ryan Doyle
-- Purpose: Extract performance trends, rolling form, and goalkeeper metrics
-- ====================================================================

-- 1. Rolling 3-Match Form & Expected Goal (xG) Differential
WITH match_metrics AS (
    SELECT 
        match_date,
        opponent,
        venue,
        result,
        goals_for,
        goals_against,
        team_xg,
        opponent_xg,
        (team_xg - opponent_xg) AS xg_differential,
        CASE WHEN result = 'W' THEN 3
             WHEN result = 'D' THEN 1
             ELSE 0 END AS points_earned
    FROM match_performance_summary
)
SELECT 
    match_date,
    opponent,
    result,
    points_earned,
    ROUND(AVG(points_earned) OVER(ORDER BY match_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3_match_ppg,
    ROUND(AVG(xg_differential) OVER(ORDER BY match_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3_match_xg_diff,
    ROUND(AVG(team_xg) OVER(ORDER BY match_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_team_xg,
    ROUND(AVG(opponent_xg) OVER(ORDER BY match_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_opponent_xg
FROM match_metrics;

-- 2. Goalkeeper Shot-Stopping & Post-Shot xG (PSxG) Efficiency
SELECT 
    match_date,
    opponent,
    goals_against,
    saves,
    (saves + goals_against) AS shots_faced,
    ROUND((saves::NUMERIC / NULLIF(saves + goals_against, 0)) * 100, 1) AS save_percentage,
    opponent_xg,
    ROUND((opponent_xg - goals_against), 2) AS goals_prevented_above_expected
FROM match_performance_summary
ORDER BY match_date ASC;

-- 3. Venue Split: Home vs. Away Performance Profile
SELECT 
    venue,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) AS draws,
    SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS losses,
    ROUND(AVG(possession_pct), 1) AS avg_possession,
    ROUND(AVG(pass_accuracy_pct), 1) AS avg_pass_acc,
    ROUND(AVG(team_xg), 2) AS avg_team_xg,
    ROUND(AVG(opponent_xg), 2) AS avg_opp_xg,
    ROUND(AVG(team_xg - opponent_xg), 2) AS net_xg_advantage
FROM match_performance_summary
GROUP BY venue;
