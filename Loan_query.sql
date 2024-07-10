use bank_loan
select * from financial_loan

-----------------------KEY PERFORMANCE INDICATORS-------------------------------------
--1.Total_Loan_Applications
SELECT COUNT('application_type') AS Total_Loan_Applications FROM financial_loan


-- Get the total number of loan applications for the current month
   WITH CurrentMonth AS (
    SELECT COUNT(application_type) AS MTD_Total_Loan_Applications
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
),

-- Get the total number of loan applications for the previous month
PreviousMonth AS (
    SELECT COUNT(application_type) AS Previous_Month_Total_Loan_Applications 
    FROM financial_loan
    WHERE YEAR(issue_date) = YEAR(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
      AND MONTH(issue_date) = MONTH(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
)

-- Calculate the MoM change percentage
SELECT 
    CM.MTD_Total_Loan_Applications,
    PM.Previous_Month_Total_Loan_Applications,
    CASE 
        WHEN PM.Previous_Month_Total_Loan_Applications = 0 THEN 0
        ELSE ((CM.MTD_Total_Loan_Applications - PM.Previous_Month_Total_Loan_Applications) * 100.0 
              / PM.Previous_Month_Total_Loan_Applications)
    END AS MoM_Change_Percentage
FROM 
    CurrentMonth CM,
    PreviousMonth PM;

--Total Funded Amount
	SELECT SUM(loan_amount) as Total_funded_amount from financial_loan
--MTD
	SELECT SUM(loan_amount) as Total_funded_amount 
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
--MOM
	 WITH CurrentMonth AS (
    SELECT SUM(loan_amount) as Current_Total_funded_amount
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
),

-- Get the total number of loan applications for the previous month
PreviousMonth AS (
    SELECT SUM(loan_amount) as Previous_Total_funded_amount 
    FROM financial_loan
    WHERE YEAR(issue_date) = YEAR(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
      AND MONTH(issue_date) = MONTH(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
)

-- Calculate the MoM change percentage
SELECT 
    CM.Current_Total_funded_amount,
    PM.Previous_Total_funded_amount ,
    CASE 
        WHEN PM.Previous_Total_funded_amount  = 0 THEN 0
        ELSE ((CM.Current_Total_funded_amount - PM.Previous_Total_funded_amount ) * 100.0 
              / PM.Previous_Total_funded_amount )
    END AS MoM_Change_Percentage
FROM 
    CurrentMonth CM,
    PreviousMonth PM;
	
--Total Amount Received
SELECT SUM(total_payment) as Total_Amount_Received FROM financial_loan
--MTD
SELECT  SUM(total_payment) as M_Total_Amount_Received
 FROM financial_loan
 WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
 AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
--MOM
 WITH CurrentMonth AS (
    SELECT SUM(total_payment) as M_Total_Amount_Received
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
),

-- Get the total number of loan applications for the previous month
PreviousMonth AS (
    SELECT SUM(total_payment) as P_Total_Amount_Received
    FROM financial_loan
    WHERE YEAR(issue_date) = YEAR(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
      AND MONTH(issue_date) = MONTH(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
)

-- Calculate the MoM change percentage
SELECT 
  CM.M_Total_Amount_Received,
  PM.P_Total_Amount_Received ,
  CASE 
  WHEN PM.P_Total_Amount_Received  = 0 THEN 0
    ELSE ((CM.M_Total_Amount_Received - PM.P_Total_Amount_Received ) * 100.0 
              / PM.P_Total_Amount_Received )
    END AS MoM_Change_Percentage
FROM 
    CurrentMonth CM,
    PreviousMonth PM;

--Average_IR
SELECT ROUND(AVG(int_rate),4)*100 as Average_IR from financial_loan
--MTD
 SELECT ROUND(AVG(int_rate),4)*100 as Monthly_Average_IR
  FROM financial_loan
  WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
  AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
--MOM
 WITH CurrentMonth AS (
    SELECT ROUND(AVG(int_rate),4)*100 as Monthly_Average_IR
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
),

-- Get the total number of loan applications for the previous month
PreviousMonth AS (
    SELECT ROUND(AVG(int_rate),4)*100 as Previous_month_Average_IR
    FROM financial_loan
    WHERE YEAR(issue_date) = YEAR(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
      AND MONTH(issue_date) = MONTH(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
)

-- Calculate the MoM change percentage
SELECT 
  CM.Monthly_Average_IR,
  PM.Previous_month_Average_IR ,
  CASE 
  WHEN PM.Previous_month_Average_IR  = 0 THEN 0
    ELSE ROUND(((CM.Monthly_Average_IR - PM.Previous_month_Average_IR) * 100.0 
              / PM.Previous_month_Average_IR ),4)
    END AS MoM_Change_Percentage
FROM 
    CurrentMonth CM,
    PreviousMonth PM;

--Average_Debt-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti),4)*100 as Average_Debt_to_Income_Ratio from financial_loan
--MTD
SELECT ROUND(AVG(dti),4)*100 as M_Average_Debt_to_Income_Ratio
  FROM financial_loan
  WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
  AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)

  --MOM
 WITH CurrentMonth AS (
    SELECT ROUND(AVG(dti),4)*100 as M_Average_Debt_to_Income_Ratio
    FROM financial_loan
    WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
      AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
),

-- Get the total number of loan applications for the previous month
PreviousMonth AS (
    SELECT ROUND(AVG(dti),4)*100 as Previous_Average_Debt_to_Income_Ratio
    FROM financial_loan
    WHERE YEAR(issue_date) = YEAR(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
      AND MONTH(issue_date) = MONTH(DATEADD(MONTH, -1, (SELECT MAX(issue_date) FROM financial_loan)))
)

-- Calculate the MoM change percentage
SELECT 
  CM.M_Average_Debt_to_Income_Ratio,
  PM.Previous_Average_Debt_to_Income_Ratio ,
  CASE 
  WHEN PM.Previous_Average_Debt_to_Income_Ratio = 0 THEN 0
    ELSE ROUND(((CM.M_Average_Debt_to_Income_Ratio - PM.Previous_Average_Debt_to_Income_Ratio) * 100.0 
              / PM.Previous_Average_Debt_to_Income_Ratio),4)
    END AS MoM_Change_Percentage
FROM 
    CurrentMonth CM,
    PreviousMonth PM;

select * from financial_loan
select distinct(loan_status) from financial_loan

--Good_Loans_Application_Percentage
SELECT(
COUNT(CASE WHEN loan_status='Fully Paid' or loan_status='Current' THEN id END)*100)/
COUNT(id) AS Good_Loans_Application_Percentage from financial_loan

--Good_Loans_Application
SELECT COUNT(id) as Good_Loans_Application from financial_loan where loan_status in ('Fully Paid','Current')

--Good_loan_funded_amount
SELECT SUM(loan_amount) as Good_loan_funded_amount from financial_loan where loan_status in ('Fully Paid','Current')

--Good_loan_amount
SELECT SUM(total_payment) as Good_loan_amount from financial_loan where loan_status in ('Fully Paid','Current')

---------------------BAD LOAN---------------------------------
--Bad_Loans_Application_Percentage
SELECT(
COUNT(CASE WHEN loan_status='Charged Off' THEN id END)*100)/
COUNT(id) AS Bad_Loans_Application_Percentage from financial_loan

--Bad_Loans_Application
SELECT COUNT(id) as Bad_Loans_Application from financial_loan where loan_status in ('Charged Off')

--Bad_loan_funded_amount
SELECT SUM(loan_amount) as Bad_loan_funded_amount from financial_loan where loan_status in ('Charged Off')

----Bad_loan_amount
SELECT SUM(total_payment) as Bad_loan_amount from financial_loan where loan_status in ('Charged Off')

------------------Loan Status Grid View--------------------------------
SELECT
loan_status,
COUNT(application_type) as Total_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received,
AVG(int_rate)*100 as Avg_IR,
AVG(dti)*100 as Avg_dti 
FROM financial_loan group by loan_status

--MTD
SELECT
loan_status,
COUNT(application_type) as M_Total_Application,
SUM(loan_amount) as M_Total_amount_funded,
SUM(total_payment) as M_Total_amount_received,
AVG(int_rate)*100 as M_Avg_IR,
AVG(dti)*100 as M_Avg_dti 
 FROM financial_loan
  WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM financial_loan)
  AND YEAR(issue_date) = (SELECT MAX(YEAR(issue_date)) FROM financial_loan)
group by loan_status

-------------------------------CHARTS--------------------------------------
---MONTHLY TREND BY ISSUE DATE
SELECT DATENAME(MONTH,issue_date) as Month_name,
MONTH(issue_date) as Month_no,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by MONTH(issue_date), DATENAME(MONTH,issue_date) 
order by MONTH(issue_date)

--REGIONAL ANALYSIS BY STATE
SELECT address_state,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by address_state

----LOAN TERM ANALYSIS
SELECT term,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by term

--EMPLOYEE LENGTH ANALYSIS
SELECT emp_length,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by emp_length
order by emp_length

--LOAN PURPOSE
SELECT purpose,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by purpose

---HOME OWNERSHIP
SELECT home_ownership,
Count(id) as Total_Loan_Application,
SUM(loan_amount) as Total_amount_funded,
SUM(total_payment) as Total_amount_received 
from financial_loan
group by home_ownership

--Verification_Status
SELECT verification_status,
Count(id) as Total_Loan_Application
from financial_loan
group by verification_status
