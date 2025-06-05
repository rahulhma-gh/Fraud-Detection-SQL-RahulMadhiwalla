use customerloandatabase
-- Task 8: Age-Based Loan Analysis
-- Analyzing borrowing patterns across age groups

SELECT 
    CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(l.loan_id) AS num_loans,
    AVG(l.loan_amount) AS avg_loan_amount,
    SUM(l.loan_amount) AS total_loan_amount
FROM customer_tableforloans c
JOIN loan_tablenew l ON c.customer_id = l.customer_id
GROUP BY age_group
ORDER BY 
    CASE 
        WHEN age_group = 'Under 30' THEN 1
        WHEN age_group = '30-50' THEN 2
        ELSE 3
    END;
    -- Task 8: Age-Based Loan Analysis (Fixed for MySQL compatibility)

SELECT 
    CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(l.loan_id) AS num_loans,
    AVG(l.loan_amount) AS avg_loan_amount,
    SUM(l.loan_amount) AS total_loan_amount
FROM customer_tableforloans c
JOIN loan_tablenew l ON c.customer_id = l.customer_id
GROUP BY 
    CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END
ORDER BY 
    CASE 
        WHEN c.age < 30 THEN 1
        WHEN c.age BETWEEN 30 AND 50 THEN 2
        ELSE 3
    END;
    -- Task 8: Age-Based Loan Analysis (fully compatible with ONLY_FULL_GROUP_BY)

SELECT 
    CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(l.loan_id) AS num_loans,
    AVG(l.loan_amount) AS avg_loan_amount,
    SUM(l.loan_amount) AS total_loan_amount
FROM customer_tableforloans c
JOIN loan_tablenew l ON c.customer_id = l.customer_id
GROUP BY 
    CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END
ORDER BY 
    CASE 
        WHEN c.age < 30 THEN 1
        WHEN c.age BETWEEN 30 AND 50 THEN 2
        ELSE 3
    END;
-- Task 8: Age-Based Loan Analysis (100% compatible with ONLY_FULL_GROUP_BY)

SELECT 
    age_group,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(l.loan_id) AS num_loans,
    AVG(l.loan_amount) AS avg_loan_amount,
    SUM(l.loan_amount) AS total_loan_amount
FROM (
    SELECT 
        c.customer_id,
        c.age,
        l.loan_id,
        l.loan_amount,
        CASE 
            WHEN c.age < 30 THEN 'Under 30'
            WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
            ELSE '50+'
        END AS age_group
    FROM customer_tableforloans c
    JOIN loan_tablenew l ON c.customer_id = l.customer_id
) AS derived
GROUP BY age_group
ORDER BY 
    CASE 
        WHEN age_group = 'Under 30' THEN 1
        WHEN age_group = '30-50' THEN 2
        ELSE 3
    END;
-- Task 8: Age-Based Loan Analysis (Strict SQL Mode - Final Fix)

SELECT 
    age_group,
    COUNT(DISTINCT customer_id) AS num_customers,
    COUNT(loan_id) AS num_loans,
    AVG(loan_amount) AS avg_loan_amount,
    SUM(loan_amount) AS total_loan_amount
FROM (
    SELECT 
        c.customer_id,
        c.age,
        l.loan_id,
        l.loan_amount,
        CASE 
            WHEN c.age < 30 THEN 'Under 30'
            WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
            ELSE '50+'
        END AS age_group
    FROM customer_tableforloans AS c
    JOIN loan_tablenew AS l ON c.customer_id = l.customer_id
) AS derived
GROUP BY age_group
ORDER BY 
    CASE 
        WHEN age_group = 'Under 30' THEN 1
        WHEN age_group = '30-50' THEN 2
        ELSE 3
    END;
-- Task 9: Seasonal Transaction Trends
-- Analyzing how transactions vary by month and year

SELECT 
    YEAR(STR_TO_DATE(transaction_date, '%m/%d/%Y')) AS txn_year,
    MONTH(STR_TO_DATE(transaction_date, '%m/%d/%Y')) AS txn_month,
    COUNT(*) AS total_transactions
FROM transaction_tablenew
GROUP BY 
    YEAR(STR_TO_DATE(transaction_date, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(transaction_date, '%m/%d/%Y'))
ORDER BY txn_year, txn_month;
SELECT 
    MONTH(STR_TO_DATE(transaction_date, '%m/%d/%Y')) AS txn_month,
    COUNT(*) AS total_txns
FROM transaction_tablenew
GROUP BY txn_month
ORDER BY total_txns DESC;
-- Task 10: Repayment History Analysis
-- Ranking loans by their EMI repayment consistency

SELECT 
    loan_id,
    COUNT(*) AS total_emi_paid,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS repayment_rank
FROM transaction_tablenew
WHERE transaction_type = 'EMI Payment'
GROUP BY loan_id
ORDER BY total_emi_paid DESC;
-- Top 5 Customers with Most EMI Payments Across Loans

SELECT 
    l.customer_id,
    COUNT(*) AS total_emi_payments
FROM transaction_tablenew t
JOIN loan_tablenew l ON t.loan_id = l.loan_id
WHERE t.transaction_type = 'EMI Payment'
GROUP BY l.customer_id
ORDER BY total_emi_payments DESC
LIMIT 5;
-- Enriched Top 5 EMI Payers with Demographic and Risk Info

SELECT 
    c.customer_id,
    c.`name`,
    c.age,
    c.income,
    COUNT(*) AS total_emi_payments,
    SUM(l.loan_amount) AS total_borrowed,
    AVG(l.default_risk) AS avg_default_risk
FROM transaction_tablenew t
JOIN loan_tablenew l ON t.loan_id = l.loan_id
JOIN customer_tableforloans c ON l.customer_id = c.customer_id
WHERE t.transaction_type = 'EMI Payment'
GROUP BY c.customer_id, c.`name`, c.age, c.income
ORDER BY total_emi_payments DESC
LIMIT 5;





