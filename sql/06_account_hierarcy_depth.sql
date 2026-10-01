-- Find the maximum depth of DimAccount's parent child hierarcy
WITH AccountHierarcy AS (
	SELECT AccountKey, ParentAccountKey, AccountName, 1 AS Level
	FROM dbo.DimAccount
	WHERE ParentAccountKey IS NULL

	UNION ALL

	SELECT d.AccountKey, d.ParentAccountKey, d.AccountName, ah.Level + 1
	FROM dbo.DimAccount d
	JOIN AccountHierarcy ah ON d.ParentAccountKey = ah.AccountKey
)
SELECT MAX(level) AS MaxDepth
FROM AccountHierarcy;