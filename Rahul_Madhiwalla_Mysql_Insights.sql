CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    income FLOAT,
    credit_score INT,
    address VARCHAR(255),
    customer_since DATE
);
USE customerloandatabase;
CREATE TABLE loan (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount FLOAT,
    loan_purpose VARCHAR(100),
    default_risk VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE transaction (
    transaction_id INT PRIMARY KEY,
    loan_id INT,
    customer_id INT,
    transaction_amount FLOAT,
    transaction_type VARCHAR(50),
    transaction_date DATE,
    FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
SELECT * FROM cusotmer_tableforloans LIMIT 10;
USE customerloandatabase;

-- TASK 1: Identify customers with low credit score & high-risk loans
SELECT 
    c.customer_id,
    c.name,
    c.credit_score,
    l.loan_id,
    l.loan_amount,
    l.default_risk
FROM 
    customer_tableforloans AS c
JOIN 
    loan_tablenew AS l 
ON 
    c.customer_id = l.customer_id
WHERE 
    c.credit_score < 600 
    AND l.default_risk = 'High';
-- TASK 1: Risky Customers (credit_score < 600 + default_risk = 'High')


