USE [MavinTelecom];

/*
Checking for duplicates
*/

-- Retrieve customer IDs that appear more than once in the telecom_customer_churn table
SELECT 
    [Customer ID],           -- Select the Customer ID column
    COUNT(*) AS Occurrence   -- Count the number of occurrences for each Customer ID, labeled as 'Occurrence'
FROM 
    [dbo].[telecom_customer_churn]  -- Data source: telecom_customer_churn table in the MavinTelecom dbo schema
GROUP BY 
    [Customer ID]            -- Group the results by Customer ID to count each one's occurrences
HAVING 
    COUNT(*) > 1;            -- Filter to return only those customers that appear more than once


-- Count the total number of customers in the telecom_customer_churn table
SELECT 
    COUNT([Customer ID]) AS [Customer Total]  -- Count of non-NULL customer IDs, labeled as 'Customer Total'
FROM 
    [dbo].[telecom_customer_churn];  -- Data is being retrieved from the 'telecom_customer_churn' table in the 'dbo' schema



/*
How many Customers joined the company within the last quater
*/
-- Calculate the starting date of the last quarter
-- Common Table Expression (CTE) to calculate the start date of the last quarter

WITH lastQuarter AS (
    SELECT 
        DATEADD(MONTH, -3, GETDATE()) AS StartOfLastQuarter  -- Subtract 3 months from the current date to get the start of the last quarter
)

-- Main query to count customers who joined in the last quarter
SELECT 
    COUNT(*) AS CustomerJoinedLastQuarter  -- Count the number of customers who joined in the last quarter
FROM 
    [dbo].[telecom_customer_churn]  -- Data source: telecom_customer_churn table in the dbo schema
WHERE 
    -- Calculate the customer's join date by subtracting their tenure (in months) from the current date
    DATEADD(MONTH, -[Tenure in Months], GETDATE()) >= 
    (
        -- Compare the calculated join date with the start of the last quarter
        SELECT StartOfLastQuarter 
        FROM lastQuarter
    );


	/*
	What is the Customer profile for a Customer that churned, joined, and stayed? Are they different?
	*/



	/*
	What are the key drivers for customer churn?
	*/

-- Select the Churn Category and Churn Reason columns along with the count of customers who churned
SELECT
    [Churn Category],        -- The broad category of churn (e.g., Service, Price, etc.)
    [Churn Reason],          -- The specific reason a customer churned (e.g., Competitor, Dissatisfaction, etc.)
    COUNT(*) AS Customers    -- Count the number of customers for each Churn Category and Churn Reason
FROM
    [dbo].[telecom_customer_churn]   -- Data source: telecom_customer_churn table in the 'dbo' schema
WHERE
    [Customer Status] = 'Churned'    -- Filter to only include customers who have 'Churned' status
GROUP BY
    [Churn Category],        -- Group results by each Churn Category
    [Churn Reason]           -- Further group results by each specific Churn Reason
ORDER BY
    COUNT(*) DESC;           -- Sort the results by the number of churned customers in descending order

/*
Is the company losing high-value customers? If so, how can they retain them?
*/



/*
WHAT CONTRACT ARE CHURNERS ON?
*/
SELECT
    [Contract],
    count(*) AS Customers,
    ROUND(count(*) * 100.0 / SUM(count(*)) OVER(), 1) AS percentage
FROM
    [dbo].[telecom_customer_churn]
WHERE
    [Customer Status] = 'Churned'
GROUP BY
    [Contract]
ORDER BY
    Customers DESC;

/*
	Do Churners have access to premium tech support
*/
SELECT
	[Premium Tech Support],
	COUNT(*) AS Customers,
	ROUND(COUNT(*)*100.0/SUM(count(*)) OVER(),1) AS Percentage
from
	[dbo].[telecom_customer_churn]
WHERE
    [Customer Status] = 'Churned'
GROUP BY
	[Premium Tech Support]
ORDER BY
    COUNT(*) DESC;

/*
WHAT INTERNET TYPE ARE THEY ON?
*/
SELECT
	[Internet Type],
	COUNT(*) AS Customers,
	ROUND(COUNT(*)*100.0/SUM(count(*)) over(),1) as percentage
FROM
	[dbo].[telecom_customer_churn]
WHERE
	[Customer Status] = 'Churned'
GROUP BY
	[Internet Type]
ORDER BY
	COUNT(*) DESC

/*
WHAT MARKETING OFFER ARE THEY ON?
*/
SELECT
	[Offer],
	count(*) AS Customers,
	ROUND (COUNT(*) *100.0 / SUM(COUNT(*)) OVER(),1) AS Percentage
FROM
	[dbo].[telecom_customer_churn]
WHERE
	[Customer Status] = 'Churned'
GROUP BY
	[Offer]
ORDER BY
	COUNT(*) DESC

/*
Do Churners have premium tech support?
*/
SELECT
	[Premium Tech Support],
	count(*) AS Customers,
	round(count(*)*100.0/sum(count(*))over(),1) as percentage
from
	[dbo].[telecom_customer_churn]
where
	[Customer Status] = 'churned'
group by
	[Premium Tech Support]
order by
	count(*) desc