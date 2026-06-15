-- ============================================================
-- SECTION 1: DATASET OVERVIEW
-- ============================================================

CREATE TABLE ibm_hr_db.total_employees AS
SELECT COUNT(*) AS total_employees
FROM ibm_hr_db.`employee attrition`;

CREATE TABLE ibm_hr_db.attrition_distribution AS
SELECT 
    Attrition,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM ibm_hr_db.`employee attrition`
GROUP BY Attrition;

CREATE TABLE ibm_hr_db.column_ranges AS
SELECT
    MIN(Age) AS min_age,                         MAX(Age) AS max_age,
    MIN(DailyRate) AS min_daily_rate,            MAX(DailyRate) AS max_daily_rate,
    MIN(MonthlyIncome) AS min_monthly_income,    MAX(MonthlyIncome) AS max_monthly_income,
    MIN(TotalWorkingYears) AS min_working_yrs,   MAX(TotalWorkingYears) AS max_working_yrs,
    MIN(YearsAtCompany) AS min_yrs_company,      MAX(YearsAtCompany) AS max_yrs_company,
    MIN(DistanceFromHome) AS min_distance,        MAX(DistanceFromHome) AS max_distance
FROM ibm_hr_db.`employee attrition`;

CREATE TABLE ibm_hr_db.null_check AS
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)               AS null_age,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END)     AS null_monthly_income,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END)         AS null_attrition,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END)        AS null_department,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END)           AS null_job_role,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END)            AS null_gender,
    SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END)     AS null_marital_status
FROM ibm_hr_db.`employee attrition`;


-- ============================================================
-- SECTION 2: DEMOGRAPHIC ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.age_group_attrition AS
SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY age_group
ORDER BY MIN(Age);

CREATE TABLE ibm_hr_db.gender_attrition AS
SELECT
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY Gender;

CREATE TABLE ibm_hr_db.marital_status_attrition AS
SELECT
    MaritalStatus,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;

CREATE TABLE ibm_hr_db.education_field AS
SELECT
    EducationField,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_workforce
FROM ibm_hr_db.`employee attrition`
GROUP BY EducationField
ORDER BY total DESC;


-- ============================================================
-- SECTION 3: DEPARTMENT & JOB ROLE ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.department_attrition AS
SELECT
    Department,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM ibm_hr_db.`employee attrition`
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

CREATE TABLE ibm_hr_db.jobrole_attrition AS
SELECT
    JobRole,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction
FROM ibm_hr_db.`employee attrition`
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

CREATE TABLE ibm_hr_db.joblevel_income AS
SELECT
    JobLevel,
    COUNT(*) AS headcount,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    MIN(MonthlyIncome) AS min_income,
    MAX(MonthlyIncome) AS max_income,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY JobLevel
ORDER BY JobLevel;


-- ============================================================
-- SECTION 4: COMPENSATION ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.income_stats AS
SELECT
    ROUND(AVG(MonthlyIncome), 2)    AS avg_income,
    MIN(MonthlyIncome)               AS min_income,
    MAX(MonthlyIncome)               AS max_income,
    ROUND(STDDEV(MonthlyIncome), 2) AS stddev_income
FROM ibm_hr_db.`employee attrition`;

CREATE TABLE ibm_hr_db.income_by_dept_attrition AS
SELECT
    Department,
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    COUNT(*) AS headcount
FROM ibm_hr_db.`employee attrition`
GROUP BY Department, Attrition
ORDER BY Department, Attrition;

CREATE TABLE ibm_hr_db.salary_hike_bands AS
SELECT
    CASE
        WHEN PercentSalaryHike < 12 THEN 'Low (<12%)'
        WHEN PercentSalaryHike BETWEEN 12 AND 16 THEN 'Medium (12-16%)'
        WHEN PercentSalaryHike BETWEEN 17 AND 21 THEN 'High (17-21%)'
        ELSE 'Very High (>21%)'
    END AS hike_band,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY hike_band
ORDER BY MIN(PercentSalaryHike);

CREATE TABLE ibm_hr_db.stock_option_attrition AS
SELECT
    StockOptionLevel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM ibm_hr_db.`employee attrition`
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;


-- ============================================================
-- SECTION 5: SATISFACTION & ENGAGEMENT ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.job_satisfaction AS
SELECT
    JobSatisfaction,
    CASE JobSatisfaction 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' 
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' 
    END AS satisfaction_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

CREATE TABLE ibm_hr_db.environment_satisfaction AS
SELECT
    EnvironmentSatisfaction,
    CASE EnvironmentSatisfaction 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' 
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' 
    END AS env_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

CREATE TABLE ibm_hr_db.worklife_balance AS
SELECT
    WorkLifeBalance,
    CASE WorkLifeBalance 
        WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good' 
        WHEN 3 THEN 'Better' WHEN 4 THEN 'Best' 
    END AS wlb_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

CREATE TABLE ibm_hr_db.job_involvement AS
SELECT
    JobInvolvement,
    CASE JobInvolvement 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' 
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' 
    END AS involvement_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY JobInvolvement
ORDER BY JobInvolvement;

CREATE TABLE ibm_hr_db.satisfaction_heatmap AS
SELECT
    JobSatisfaction,
    EnvironmentSatisfaction,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY JobSatisfaction, EnvironmentSatisfaction
ORDER BY JobSatisfaction, EnvironmentSatisfaction;


-- ============================================================
-- SECTION 6: TRAVEL & DISTANCE ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.business_travel_attrition AS
SELECT
    BusinessTravel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM ibm_hr_db.`employee attrition`
GROUP BY BusinessTravel
ORDER BY attrition_rate_pct DESC;

CREATE TABLE ibm_hr_db.distance_bands AS
SELECT
    CASE
        WHEN DistanceFromHome <= 5   THEN 'Very Close (1-5 km)'
        WHEN DistanceFromHome <= 10  THEN 'Close (6-10 km)'
        WHEN DistanceFromHome <= 20  THEN 'Moderate (11-20 km)'
        ELSE 'Far (21+ km)'
    END AS distance_band,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY distance_band
ORDER BY MIN(DistanceFromHome);


-- ============================================================
-- SECTION 7: TENURE & CAREER PROGRESSION
-- ============================================================

CREATE TABLE ibm_hr_db.tenure_bands AS
SELECT
    CASE
        WHEN YearsAtCompany <= 2  THEN '0-2 yrs'
        WHEN YearsAtCompany <= 5  THEN '3-5 yrs'
        WHEN YearsAtCompany <= 10 THEN '6-10 yrs'
        WHEN YearsAtCompany <= 20 THEN '11-20 yrs'
        ELSE '20+ yrs'
    END AS tenure_band,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY tenure_band
ORDER BY MIN(YearsAtCompany);

CREATE TABLE ibm_hr_db.years_since_promotion AS
SELECT
    YearsSinceLastPromotion,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

CREATE TABLE ibm_hr_db.num_companies_worked AS
SELECT
    NumCompaniesWorked,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM ibm_hr_db.`employee attrition`
GROUP BY NumCompaniesWorked
ORDER BY NumCompaniesWorked;

CREATE TABLE ibm_hr_db.training_times AS
SELECT
    TrainingTimesLastYear,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;


-- ============================================================
-- SECTION 8: OVERTIME IMPACT
-- ============================================================

CREATE TABLE ibm_hr_db.overtime_attrition AS
SELECT
    OverTime,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction
FROM ibm_hr_db.`employee attrition`
GROUP BY OverTime;

CREATE TABLE ibm_hr_db.overtime_by_dept AS
SELECT
    Department,
    OverTime,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY Department, OverTime
ORDER BY Department, OverTime;


-- ============================================================
-- SECTION 9: PERFORMANCE & RELATIONSHIP ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.performance_rating AS
SELECT
    PerformanceRating,
    CASE PerformanceRating 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Good' 
        WHEN 3 THEN 'Excellent' WHEN 4 THEN 'Outstanding' 
    END AS rating_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(PercentSalaryHike), 2) AS avg_salary_hike
FROM ibm_hr_db.`employee attrition`
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

CREATE TABLE ibm_hr_db.relationship_satisfaction AS
SELECT
    RelationshipSatisfaction,
    CASE RelationshipSatisfaction 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' 
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' 
    END AS rel_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY RelationshipSatisfaction
ORDER BY RelationshipSatisfaction;

CREATE TABLE ibm_hr_db.manager_tenure AS
SELECT
    CASE
        WHEN YearsWithCurrManager = 0  THEN 'New Manager'
        WHEN YearsWithCurrManager <= 2 THEN '1-2 yrs'
        WHEN YearsWithCurrManager <= 5 THEN '3-5 yrs'
        ELSE '6+ yrs'
    END AS mgr_tenure_band,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY mgr_tenure_band
ORDER BY MIN(YearsWithCurrManager);


-- ============================================================
-- SECTION 10: MULTIVARIATE / ADVANCED ANALYSIS
-- ============================================================

CREATE TABLE ibm_hr_db.high_risk_profiles AS
SELECT
    Department,
    JobRole,
    OverTime,
    BusinessTravel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(JobSatisfaction), 2) AS avg_satisfaction
FROM ibm_hr_db.`employee attrition`
GROUP BY Department, JobRole, OverTime, BusinessTravel
HAVING COUNT(*) > 5
ORDER BY attrition_rate_pct DESC
LIMIT 20;

CREATE TABLE ibm_hr_db.employee_risk_scores AS
SELECT
    EmployeeNumber,
    Age,
    Department,
    JobRole,
    MonthlyIncome,
    Attrition,
    (
        CASE WHEN OverTime = 'Yes' THEN 2 ELSE 0 END
      + CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 
             WHEN BusinessTravel = 'Travel_Rarely' THEN 1 ELSE 0 END
      + CASE WHEN JobSatisfaction = 1 THEN 3 WHEN JobSatisfaction = 2 THEN 2 
             WHEN JobSatisfaction = 3 THEN 1 ELSE 0 END
      + CASE WHEN WorkLifeBalance = 1 THEN 3 WHEN WorkLifeBalance = 2 THEN 2 ELSE 0 END
      + CASE WHEN EnvironmentSatisfaction = 1 THEN 2 WHEN EnvironmentSatisfaction = 2 THEN 1 ELSE 0 END
      + CASE WHEN StockOptionLevel = 0 THEN 2 WHEN StockOptionLevel = 1 THEN 1 ELSE 0 END
      + CASE WHEN YearsSinceLastPromotion >= 5 THEN 2 
             WHEN YearsSinceLastPromotion >= 3 THEN 1 ELSE 0 END
      + CASE WHEN DistanceFromHome > 20 THEN 1 ELSE 0 END
    ) AS risk_score
FROM ibm_hr_db.`employee attrition`
ORDER BY risk_score DESC, MonthlyIncome ASC
LIMIT 50;

CREATE TABLE ibm_hr_db.dept_satisfaction_income AS
SELECT
    Department,
    ROUND(AVG(MonthlyIncome), 2)            AS avg_income,
    ROUND(AVG(JobSatisfaction), 2)          AS avg_job_satisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2)  AS avg_env_satisfaction,
    ROUND(AVG(WorkLifeBalance), 2)          AS avg_wlb,
    ROUND(AVG(RelationshipSatisfaction), 2) AS avg_rel_satisfaction,
    COUNT(*) AS headcount
FROM ibm_hr_db.`employee attrition`
GROUP BY Department;

CREATE TABLE ibm_hr_db.stayers_vs_leavers AS
SELECT
    Attrition,
    ROUND(AVG(Age), 1)                      AS avg_age,
    ROUND(AVG(MonthlyIncome), 2)            AS avg_income,
    ROUND(AVG(YearsAtCompany), 1)           AS avg_tenure,
    ROUND(AVG(TotalWorkingYears), 1)        AS avg_total_exp,
    ROUND(AVG(JobSatisfaction), 2)          AS avg_job_satisfaction,
    ROUND(AVG(WorkLifeBalance), 2)          AS avg_wlb,
    ROUND(AVG(DistanceFromHome), 1)         AS avg_distance,
    ROUND(AVG(TrainingTimesLastYear), 1)    AS avg_trainings,
    ROUND(AVG(NumCompaniesWorked), 1)       AS avg_companies,
    ROUND(AVG(PercentSalaryHike), 1)        AS avg_salary_hike,
    SUM(CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END) AS overtime_count,
    COUNT(*) AS total
FROM ibm_hr_db.`employee attrition`
GROUP BY Attrition;

CREATE TABLE ibm_hr_db.income_inequality_by_role AS
SELECT
    JobRole,
    MIN(MonthlyIncome) AS min_income,
    MAX(MonthlyIncome) AS max_income,
    ROUND(MAX(MonthlyIncome) / MIN(MonthlyIncome), 2) AS income_ratio,
    ROUND(STDDEV(MonthlyIncome), 2) AS income_stddev,
    COUNT(*) AS headcount
FROM ibm_hr_db.`employee attrition`
GROUP BY JobRole
ORDER BY income_ratio DESC;

CREATE TABLE ibm_hr_db.retention_by_education AS
SELECT
    Education,
    CASE Education
        WHEN 1 THEN 'Below College'
        WHEN 2 THEN 'College'
        WHEN 3 THEN 'Bachelor'
        WHEN 4 THEN 'Master'
        WHEN 5 THEN 'Doctor'
    END AS education_label,
    EducationField,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS retained,
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS retention_rate_pct
FROM ibm_hr_db.`employee attrition`
GROUP BY Education, EducationField
ORDER BY retention_rate_pct ASC;