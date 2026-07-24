<img width="1376" height="768" alt="watermarked_img_2100305283205704660" src="https://github.com/user-attachments/assets/d9811990-c7ec-45d4-ace4-c07e4aa9da05" />



# Healthcare Readmissions & Clinical Quality Audit

## Business Overview
Hospital readmissions within 30 days of discharge serve as a critical indicator of healthcare quality and operational effectiveness. This repository analyzes federal hospital readmissions and mortality data to benchmark facility performance, identify high-risk clinical conditions, and evaluate state-level healthcare quality disparities.

* **Full Dataset:** [US Healthcare Readmissions and Mortality Dataset](https://www.kaggle.com/datasets/thedevastator/us-healthcare-readmissions-and-mortality) on Kaggle
* **Sample Schema Preview:** [`data/sample_hospital_readmissions.csv`](data/sample_hospital_readmissions.csv)

---

## Key Analytics & Audit Findings

| Audit Focus | Business Question | SQL Technique |
| :--- | :--- | :--- |
| **Clinical Risk Benchmarking** | Which medical conditions (e.g., Heart Failure, COPD) show the highest average 30-day readmission rates? | Aggregated `AVG(Score)` across clinical measure categories (`Measure_Name LIKE '%READM%'`). |
| **Geographic Disparities** | Which states have the highest proportion of hospitals performing below national quality benchmarks? | Calculated underperforming hospital percentages using conditional aggregation (`CASE WHEN Compared_to_National = 'Worse Than National Rate'`). |
| **Healthcare Staging Layer** | How do we standardize non-numeric entries and prepare clean facility records for BI dashboards? | Engineered `vw_hospital_quality_audit` view casting scores to numeric decimals and filtering invalid entries. |

---

## Tech Stack
* **Language:** SQL (PostgreSQL / MySQL)
* **Domain:** Healthcare Operations, Clinical Quality Analytics, Risk Benchmarking
