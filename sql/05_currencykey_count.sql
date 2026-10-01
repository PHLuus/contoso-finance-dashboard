-- Confrim the dataset uses a single currency throughout
SELECT CurrencyKey, COUNT(*) AS RowTotal
FROM dbo.FactStrategyPlan
GROUP BY CurrencyKey;