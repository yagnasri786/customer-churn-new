-- 1. Top 10 highest paying customers
SELECT Customer_ID, Total_Charges
FROM customer_data
ORDER BY Total_Charges DESC
LIMIT 10;

-- 2. Total number of churned vs non-churned customers
SELECT Customer_Status, COUNT(*) AS customer_count
FROM customer_data
GROUP BY Customer_Status;
-- 3. Gender-wise churn distribution
SELECT Gender,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS churn_percent
FROM customer_data
GROUP BY Gender;

-- 4. Average tenure of churned vs active customers
SELECT Customer_Status, ROUND(AVG(Tenure_in_Months), 2) AS avg_tenure
FROM customer_data
GROUP BY Customer_Status;
--  5. Churn rate by Value Deal (similar to plan type)
SELECT Value_Deal,
       COUNT(*) AS total,
       SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned,
       ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS churn_rate
FROM customer_data
GROUP BY Value_Deal
ORDER BY churn_rate DESC;
 -- 6. Monthly revenue loss due to churn
SELECT SUM(Monthly_Charge) AS monthly_loss
FROM customer_data
WHERE Customer_Status = 'Churned';
 -- 7. Top 10 churned customers with highest billing issues (use Total_Extra_Data_Charges as proxy)
 SELECT Customer_ID, Total_Extra_Data_Charges
FROM customer_data
WHERE Customer_Status = 'Churned'
ORDER BY Total_Extra_Data_Charges DESC
LIMIT 10;
-- 8. Churn based on long distance charges (as a service interaction proxy)
SELECT ROUND(Total_Long_Distance_Charges, 0) AS Calls_Bracket,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_data
GROUP BY Calls_Bracket
ORDER BY Calls_Bracket;
-- 10. Average charges comparison
SELECT Customer_Status,
       ROUND(AVG(Monthly_Charge), 2) AS avg_monthly,
       ROUND(AVG(Total_Charges), 2) AS avg_total
FROM customer_data
GROUP BY Customer_Status;
-- 14. Average long distance charges by churn status (proxy for customer interaction)
SELECT Customer_Status, ROUND(AVG(Total_Long_Distance_Charges), 2) AS avg_calls
FROM customer_data
GROUP BY Customer_Status;


