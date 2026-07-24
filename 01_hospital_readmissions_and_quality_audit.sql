-- =====================================================================
-- HEALTHCARE OPERATIONS & HOSPITAL QUALITY AUDIT
-- Author: Renee Jon Orias
-- Dataset: US Healthcare Readmissions & Mortality Rates (Kaggle)
-- Objective: Audit 30-day hospital readmission performance, identify
--            high-risk clinical measures, and aggregate state quality metrics.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. HIGH-RISK READMISSION MEASURE BENCHMARKING
-- Compare average hospital readmission scores against national baselines
-- ---------------------------------------------------------------------

SELECT 
    Measure_Name,
    COUNT(DISTINCT Provider_ID) AS total_hospitals_reporting,
    ROUND(AVG(CAST(Score AS DECIMAL(10,2))), 2) AS avg_readmission_score,
    ROUND(MIN(CAST(Score AS DECIMAL(10,2))), 2) AS best_hospital_score,
    ROUND(MAX(CAST(Score AS DECIMAL(10,2))), 2) AS worst_hospital_score
FROM hospital_readmissions_raw
WHERE Measure_Name LIKE '%READM%' 
  AND Score IS NOT NULL 
  AND Score NOT LIKE '%Not Available%'
GROUP BY Measure_Name
ORDER BY avg_readmission_score DESC;

-- ---------------------------------------------------------------------
-- 2. STATE-LEVEL QUALITY PERFORMANCE SEGMENTATION
-- Categorize states by percentage of hospitals performing worse than national average
-- ---------------------------------------------------------------------

SELECT 
    State,
    COUNT(DISTINCT Provider_ID) AS total_hospitals,
    SUM(CASE WHEN Compared_to_National = 'Worse Than National Rate' THEN 1 ELSE 0 END) AS underperforming_hospitals,
    ROUND(
        SUM(CASE WHEN Compared_to_National = 'Worse Than National Rate' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(DISTINCT Provider_ID), 0), 2
    ) AS pct_underperforming
FROM hospital_readmissions_raw
WHERE Compared_to_National IS NOT NULL
GROUP BY State
HAVING total_hospitals >= 10
ORDER BY pct_underperforming DESC;

-- ---------------------------------------------------------------------
-- 3. SANITIZED HOSPITAL QUALITY ANALYTICS VIEW
-- Create clean staging layer for dashboard reporting with masked contact details
-- ---------------------------------------------------------------------

CREATE VIEW vw_hospital_quality_audit AS
SELECT 
    Provider_ID AS hospital_id,
    Hospital_Name,
    City,
    State,
    ZIP_Code,
    Measure_Name,
    CAST(Score AS DECIMAL(10,2)) AS readmission_score,
    Compared_to_National AS national_benchmark_comparison,
    Measure_Start_Date,
    Measure_End_Date
FROM hospital_readmissions_raw
WHERE Score IS NOT NULL AND Score NOT LIKE '%Not Available%';
