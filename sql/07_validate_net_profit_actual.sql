-- Validate Powe BI's signed Net Profit (Actual) fugure independently 
WITH SignPath AS (
    SELECT 
        AccountKey, 
        ParentAccountKey,
        CASE WHEN Operator = '-' THEN -1 ELSE 1 END AS CumulativeSign
    FROM dbo.DimAccount
    WHERE ParentAccountKey IS NULL

    UNION ALL

    SELECT 
        d.AccountKey,
        d.ParentAccountKey,
        sp.CumulativeSign * CASE WHEN d.Operator = '-' THEN -1 ELSE 1 END
    FROM dbo.DimAccount d
    JOIN SignPath sp ON d.ParentAccountKey = sp.AccountKey
)
SELECT SUM(f.Amount * sp.CumulativeSign) AS NetTotal
FROM dbo.FactStrategyPlan f
JOIN SignPath sp ON f.AccountKey = sp.AccountKey
JOIN dbo.DimScenario ds ON f.ScenarioKey = ds.ScenarioKey
WHERE ds.ScenarioName = 'Actual';