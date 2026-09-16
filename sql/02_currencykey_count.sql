SELECT CurrencyKey, COUNT(*) AS RowTotal
FROM dbo.FactStrategyPlan
GROUP BY CurrencyKey;