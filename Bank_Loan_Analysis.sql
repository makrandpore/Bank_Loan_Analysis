USE Bank_Loan_DB;


------------------------------------------------KPI-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
------------------------------
SELECT * FROM bank_loan_data;

--Total_Applications

SELECT count(id) as Total_Applications
FROM
bank_loan_data;

-- Month to Date total applications

SELECT count(id) as MTD_Total_Applications
FROM
bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) =2021;

-- Previous month to date total applications

SELECT count(id) as Previous_MTD_Total_Applications
FROM
bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) =2021;

-- Month on Month

SELECT
    COUNT(CASE
        WHEN MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
        THEN id
    END) AS MTD_Total_Applications,

    COUNT(CASE
        WHEN MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
        THEN id
    END) AS Previous_MTD_Total_Applications,

    ROUND(
        (
            COUNT(CASE
                WHEN MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
                THEN id
            END)
            -
            COUNT(CASE
                WHEN MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
                THEN id
            END)
        )
        * 100.0
        /
        NULLIF(
            COUNT(CASE
                WHEN MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
                THEN id
            END),
            0
        ),
        2
    ) AS MoM_Percentage
FROM bank_loan_data;

-- Total Funded Amount
SELECT SUM(loan_amount) as Total_Funded_Amount
FROM 
bank_loan_data;

-- MTD Total Funded Amount
SELECT SUM(loan_amount) as MTD_Total_Funded_Amount
FROM 
bank_loan_data
where MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous MTD Total Funded Amount
SELECT SUM(loan_amount) as PMTD_Total_Funded_Amount
FROM 
bank_loan_data
where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Total Received Amount
SELECT SUM(total_payment) as total_amount_received
FROM
bank_loan_data;

-- MTD Total Received Amount
SELECT SUM(total_payment) as MTD_total_amount_received
FROM
bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous MTD Total Received Amount

SELECT SUM(total_payment) as PMTD_total_amount_received
FROM
bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- AVG_Int_Rate 

SELECT ROUND(AVG(int_rate) * 100,2) as AVG_Int_Rate
FROM
bank_loan_data;

---- MTD_AVG_Int_Rate 

SELECT ROUND(AVG(int_rate) * 100,2) as MTD_AVG_Int_Rate
FROM
bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

----PMTD_AVG_Int_Rate 

SELECT ROUND(AVG(int_rate) * 100,2) as PMTD_AVG_Int_Rate 
FROM
bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- AVG_Int_Rate 

SELECT ROUND(AVG(dti) * 100,2) as AVG_dti
FROM
bank_loan_data;

---- MTD_AVG_Int_Rate 

SELECT ROUND(AVG(dti) * 100,2) as MTD_AVG_dti
FROM
bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

----PMTD_AVG_Int_Rate 

SELECT ROUND(AVG(dti) * 100,2) as PMTD_AVG_dti 
FROM
bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

SELECT
    (COUNT
    (CASE 
    WHEN loan_status = 'Fully Paid' 
    OR 
    loan_status = 'Current' THEN id END) * 100)/
    COUNT(id)  as Good_Loan_perc
FROM bank_loan_data;

-- Count of Good Loan Amount
SELECT COUNT(id)
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';



-- Good Loan Funded Amount
SELECT SUM(loan_amount) as Good_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status IN ('Fully Paid','Current');

-- Total payment received
SELECT SUM(total_payment) as Good_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status IN ('Fully Paid','Current');

-- Total % of Bad Loan

SELECT
    (COUNT(CASE 
    WHEN loan_status = 'Charged Off' THEN id END) * 100)/
    COUNT(id)  as Good_Loan_perc
FROM bank_loan_data;

--Total bad loan applications

SELECT COUNT(id) as Bad_Loan_Applications
FROM 
bank_loan_data
WHERE loan_status = 'Charged Off';

-- TOtal Of Bad Loan Funded
SELECT SUM(loan_amount) as Bad_Loan_Funded_Applications
FROM 
bank_loan_data
WHERE loan_status = 'Charged Off';

-- Total Bad Loan Amount received
SELECT SUM(total_payment) as Bad_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- Loan Status Grid View
SELECT
    loan_status,
    count(id) as Total_Loan_Applications,
    sum(total_payment) as Total_Amount_Received,
    SUM(loan_amount) as Total_Funded_Amount,
    ROUND(AVG(int_rate * 100),2)  as Int_Rate,
    ROUND(AVG(dti * 100),2)  as DTI
FROM
    bank_loan_data
GROUP BY
    loan_status;

-- MTD & Amount Received and MTD Amount Funded

SELECT
    loan_status,
    SUM(total_payment) as MTD_Total_Amount_Received,
    SUM(loan_amount) as MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) =12
GROUP BY loan_status;

--Overview Dashboard Analysis (Dashboard 2)
-- Monthly Trends by Issue date 

SELECT * FROM bank_loan_data;

SELECT 
    month(issue_date) as Month_Number,
    DATENAME(Month, issue_date) as Month_Name,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY Month(issue_date),DATENAME(Month, issue_date)
ORDER BY Month(issue_date);

-- Monthly Trends by Address State

SELECT
    address_state,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY address_state
ORDER BY SUM(loan_amount) desc;

-- Loan Term Analysis

SELECT
    term,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY term
ORDER BY term;

-- Employee Length

SELECT
    emp_length,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) desc;

-- Purpose

SELECT
    purpose,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) desc;

-- Home Ownweship
SELECT
    home_ownership,
    COUNT(id) as Total_Loan_Applications,
    SUM(loan_amount) as Total_Funded_Amount,
    SUM(total_payment) as Total_Received_Amount
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) desc;

----------------------------------------------------------





























