use customerloandatabase
-- TASK 1: Risky Customers
-- TASK 2: Loan Purpose Insights
-- TASK 3: High-Value Transactions (completed)
-- TASK 4: Count Missed EMI Payments by Loan
SELECT 
    loan_id,
    COUNT(*) AS missed_emi_count
FROM 
    transaction_tablenew;
WHERE 
    `transaction_type` = 'Missed EMI'
GROUP BY 
    loan_id
ORDER BY 
    missed_emi_count DESC;



DESCRIBE transaction_tablenew;
USE customerloandatabase;

-- TASK 4: Missed EMI Count Per Loan
SELECT 
    loan_id,
    COUNT(*) AS missed_emi_count
FROM 
    transaction_tablenew
WHERE 
    `transaction_type` = 'Missed EMI'
GROUP BY 
    loan_id
ORDER BY 
    missed_emi_count DESC;
USE customerloandatabase;

-- TASK 5: Loan Distribution by Region (Assumed Region = State Code)
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(c.address, ',', -2), ',', 1)
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount,
    ROUND(AVG(l.loan_amount), 2) AS avg_loan_amount
FROM 
    customer_tableforloans AS c
JOIN 
    loan_tablenew AS l ON c.customer_id = l.customer_id
GROUP BY 
    region
ORDER BY 
    total_loans DESC;
    USE customerloandatabase;

-- TASK 5: Loan Distribution by Region (Assumed Region = State Code)
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(c.address, ',', -1), ' ', 1) AS region,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount,
    ROUND(AVG(l.loan_amount), 2) AS avg_loan_amount
FROM 
    customer_tableforloan AS c
JOIN 
    loan_tablenew AS l ON c.customer_id = l.customer_id
GROUP BY 
    region
ORDER BY 
    total_loans DESC;
    
    USE customerloandatabase;

-- TASK 5: Loan Distribution by US State (from address)
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(c.address, ',', -2), ',', 1)) AS state_code,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_value,
    ROUND(AVG(l.loan_amount), 2) AS avg_loan_amount
FROM 
    customer_tableforloans AS c
JOIN 
    loan_tablenew AS l ON c.customer_id = l.customer_id
GROUP BY 
    state_code
ORDER BY 
    total_loans DESC;
    use customerloandatabase
    -- Task 6: Loyal Customers - Customers associated for over 5 years
SELECT
    c.customer_id,
    c.`name`,
    c.customer_since,
    TIMESTAMPDIFF(YEAR, c.customer_since, STR_TO_DATE('2025-05-28', '%Y-%m-%d')) AS years_with_bank,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    AVG(l.default_risk) AS avg_default_risk
FROM customer_tableforloans c
JOIN loan_tablenew l ON c.customer_id = l.customer_id
WHERE TIMESTAMPDIFF(YEAR, c.customer_since, STR_TO_DATE('2025-05-28', '%Y-%m-%d')) > 5
GROUP BY 
    c.customer_id,
    c.`name`,
    c.customer_since;
SELECT customer_id, `name`, customer_since
FROM customer_tableforloans
ORDER BY customer_since
LIMIT 10;
DESCRIBE customer_tableforloans;
SELECT DISTINCT customer_since FROM customer_tableforloans LIMIT 20;
-- Task 6: Loyal Customers - Customers associated for over 5 years
SELECT 
    c.customer_id,
    c.`name`,
    c.customer_since,
    TIMESTAMPDIFF(YEAR, STR_TO_DATE(c.customer_since, '%m/%d/%Y'), STR_TO_DATE('2025-05-28', '%Y-%m-%d')) AS years_with_bank,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    AVG(l.default_risk) AS avg_default_risk
FROM customer_tableforloans c
JOIN loan_tablenew l ON c.customer_id = l.customer_id
WHERE TIMESTAMPDIFF(YEAR, STR_TO_DATE(c.customer_since, '%m/%d/%Y'), STR_TO_DATE('2025-05-28', '%Y-%m-%d')) > 5
GROUP BY 
    c.customer_id,
    c.`name`,
    c.customer_since;
    SELECT 
    l.loan_id,
    l.customer_id,
    l.loan_amount,
    COUNT(t.transaction_id) AS total_emi_paid
FROM loan_tablenew l
JOIN transaction_tablenew t ON l.loan_id = t.loan_id
WHERE t.transaction_type = 'EMI Payment'
  AND l.loan_id NOT IN (
      SELECT loan_id
      FROM transaction_tablenew
      WHERE transaction_type = 'Missed EMI'
SELECT 
    COUNT(*) AS loan_count,
    total_emi_paid
FROM (
    SELECT loan_id, COUNT(*) AS total_emi_paid
    FROM transaction_tablenew
    WHERE transaction_type = 'EMI Payment'
    GROUP BY loan_id
    HAVING SUM(transaction_type = 'Missed EMI') = 0
) AS t
GROUP BY total_emi_paid
ORDER BY total_emi_paid DESC;

  )
GROUP BY l.loan_id, l.customer_id, l.loan_amount
ORDER BY total_emi_paid DESC;
SELECT DISTINCT transaction_type
FROM transaction_tablenew;
SELECT      c.customer_id,     c.`name`,     c.customer_since,     TIMESTAMPDIFF(YEAR, c.customer_since, STR_TO_DATE('2025-05-28', '%Y-%m-%d')) AS years_with_bank,     COUNT(l.loan_id) AS total_loans,     SUM(l.loan_amount) AS total_loan_amount,     AVG(l.default_risk) AS avg_default_risk FROM customer_tableforloans c JOIN loan_tablenew l ON c.customer_id = l.customer_id WHERE TIMESTAMPDIFF(YEAR, c.customer_since, STR_TO_DATE('2025-05-28', '%Y-%m-%d')) > 5 GROUP BY      c.customer_id,     c.`name`,     c.customer_since LIMIT 0, 1000









