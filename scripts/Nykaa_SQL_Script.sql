-- =============================================================================
-- Project: Nykaa Product Retention & Customer Lifetime Value (LTV) Analytics
-- Dialect: MySQL 8.0+ (MySQL Workbench Compatible)
-- Table Name: nykaa_retention_data
-- =============================================================================

USE nykaa_db;

-- -----------------------------------------------------------------------------
-- STEP 0: FIX DATE FORMAT STRINGS (Handles M/D/YYYY, M/D/YYYY H:i, YYYY-MM-DD)
-- -----------------------------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

-- Convert string dates stored as 'M/D/YYYY' or 'M/D/YYYY H:i' or 'YYYY-MM-DD'
UPDATE nykaa_retention_data 
SET Order_Date = COALESCE(
    STR_TO_DATE(Order_Date, '%c/%e/%Y %H:%i:%s'),
    STR_TO_DATE(Order_Date, '%c/%e/%Y %H:%i'),
    STR_TO_DATE(Order_Date, '%c/%e/%Y'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y %H:%i:%s'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y'),
    STR_TO_DATE(Order_Date, '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(Order_Date, '%Y-%m-%d')
)
WHERE Order_Date IS NOT NULL AND Order_Date NOT LIKE '202%-%;';

SET SQL_SAFE_UPDATES = 1;

-- Modify Order_Date column to DATETIME type
ALTER TABLE nykaa_retention_data 
MODIFY COLUMN Order_Date DATETIME;


-- -----------------------------------------------------------------------------
-- SECTION 1: MONTHLY COHORT RETENTION MATRIX
-- Objective: Track month-over-month active user retention starting from initial order.
-- -----------------------------------------------------------------------------

WITH UserFirstOrder AS (
    -- Step 1: Identify acquisition cohort and first purchase timestamp for each user
    SELECT 
        User_ID,
        MIN(Order_Date) AS first_order_date,
        DATE_FORMAT(MIN(Order_Date), '%Y-%m-01') AS cohort_month
    FROM nykaa_retention_data
    GROUP BY User_ID
),
UserMonthlyActivity AS (
    -- Step 2: Calculate month gap (period_number) using native TIMESTAMPDIFF
    SELECT 
        o.User_ID,
        f.cohort_month,
        TIMESTAMPDIFF(MONTH, f.first_order_date, o.Order_Date) AS period_number
    FROM nykaa_retention_data o
    INNER JOIN UserFirstOrder f 
        ON o.User_ID = f.User_ID
),
CohortCounts AS (
    -- Step 3: Count distinct active users per cohort and period
    SELECT 
        cohort_month,
        period_number,
        COUNT(DISTINCT User_ID) AS active_users
    FROM UserMonthlyActivity
    GROUP BY cohort_month, period_number
),
CohortSizes AS (
    -- Step 4: Extract base cohort size at Period 0
    SELECT 
        cohort_month,
        active_users AS cohort_size
    FROM CohortCounts
    WHERE period_number = 0
)
-- Step 5: Output full cohort matrix with active counts and retention percentage
SELECT 
    c.cohort_month,
    s.cohort_size,
    c.period_number,
    c.active_users,
    ROUND((c.active_users / s.cohort_size) * 100, 2) AS retention_rate_pct
FROM CohortCounts c
INNER JOIN CohortSizes s 
    ON c.cohort_month = s.cohort_month
ORDER BY c.cohort_month ASC, c.period_number ASC;


-- -----------------------------------------------------------------------------
-- SECTION 2: RFM CUSTOMER BEHAVIORAL SEGMENTATION
-- Objective: Score and segment users into behavioral tiers using NTILE windowing.
-- -----------------------------------------------------------------------------

WITH RawRFM AS (
    -- Step 1: Calculate Recency (days), Frequency (orders), and Monetary (spend)
    SELECT 
        User_ID,
        DATEDIFF('2026-01-01', MAX(Order_Date)) AS recency_days,
        COUNT(Order_ID) AS frequency,
        SUM(Order_Value) AS monetary_value
    FROM nykaa_retention_data
    GROUP BY User_ID
),
ScoredRFM AS (
    -- Step 2: Score users into quartiles (1-4) using NTILE
    SELECT 
        User_ID,
        recency_days,
        frequency,
        monetary_value,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS R_Score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS M_Score
    FROM RawRFM
),
UserSegments AS (
    -- Step 3: Categorize into behavioral segments
    SELECT 
        User_ID,
        recency_days,
        frequency,
        monetary_value,
        R_Score,
        F_Score,
        M_Score,
        CASE 
            WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champions / Privé VIPs'
            WHEN F_Score >= 3 THEN 'Loyal Repeat Buyers'
            WHEN R_Score = 1 THEN 'At Risk / Churned'
            ELSE 'Occasional Shoppers'
        END AS customer_segment
    FROM ScoredRFM
)
-- Step 4: Final user-level output
SELECT 
    User_ID,
    recency_days,
    frequency,
    monetary_value,
    customer_segment
FROM UserSegments
ORDER BY monetary_value DESC;


-- -----------------------------------------------------------------------------
-- SECTION 3: AGGREGATED SEGMENT METRICS FOR REPORTING
-- Objective: Output aggregated metrics per RFM segment.
-- -----------------------------------------------------------------------------

WITH RawRFM AS (
    SELECT 
        User_ID,
        DATEDIFF('2026-01-01', MAX(Order_Date)) AS recency_days,
        COUNT(Order_ID) AS frequency,
        SUM(Order_Value) AS monetary_value
    FROM nykaa_retention_data
    GROUP BY User_ID
),
ScoredRFM AS (
    SELECT 
        User_ID,
        recency_days,
        frequency,
        monetary_value,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS R_Score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS M_Score
    FROM RawRFM
),
UserSegments AS (
    SELECT 
        User_ID,
        recency_days,
        frequency,
        monetary_value,
        CASE 
            WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champions / Privé VIPs'
            WHEN F_Score >= 3 THEN 'Loyal Repeat Buyers'
            WHEN R_Score = 1 THEN 'At Risk / Churned'
            ELSE 'Occasional Shoppers'
        END AS customer_segment
    FROM ScoredRFM
)
SELECT 
    customer_segment,
    COUNT(User_ID) AS total_users,
    ROUND(AVG(recency_days), 1) AS avg_recency_days,
    ROUND(AVG(frequency), 2) AS avg_orders_per_user,
    ROUND(AVG(monetary_value), 2) AS avg_monetary_spend,
    ROUND(SUM(monetary_value), 2) AS total_segment_revenue
FROM UserSegments
GROUP BY customer_segment
ORDER BY total_segment_revenue DESC;