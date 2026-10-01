-- Confrim the real date range covered by FactStrategyPlan
SELECT 
	MIN(DateKey) AS MinDate,
	MAX(DateKey) AS MaxDate
FROM dbo.FactStrategyPlan;