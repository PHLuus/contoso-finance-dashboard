# Data Dictionary

## DimAccount
Chart of accounts with a 7-level parent-child hierarchy.

| Column | Type | Description |
|---|---|---|
| AccountKey | Integer | Primary key, joins to FactStrategyPlan |
| AccountName | Text | Account name (e.g. "Marketing Cost") |
| AccountType | Text | Income / Expense / Taxation |
| Operator | Text | + or - ; this account's sign relative to its immediate parent |
| ParentAccountKey | Integer | Self-referencing FK; NULL for the root account |
| AccountPath | Text | DAX `PATH()` output — full ancestor chain as text |
| Level1–Level7 | Integer | Ancestor AccountKey at each hierarchy level (via `PATHITEM`) |
| Level1Name–Level7Name | Text | Ancestor AccountName at each level (via `LOOKUPVALUE`), used for the Matrix drill-down |
| OperatorSign | Integer | Operator converted to 1 / -1 |
| Level1OpSign–Level7OpSign | Integer | OperatorSign at each ancestor level |
| CumulativeSign | Integer | Product of every ancestor's OperatorSign — the true sign to apply to this account's amounts |

## DimScenario
| Column | Type | Description |
|---|---|---|
| ScenarioKey | Integer | Primary key, joins to FactStrategyPlan |
| ScenarioName | Text | Actual / Budget / Forecast |

## DimDate
Custom date table, built with DAX `CALENDAR()` rather than imported, to exactly match FactStrategyPlan's date range (2007-01-01 to 2009-12-31). Marked as the model's official date table.

| Column | Type | Description |
|---|---|---|
| Date | Date | One row per day |
| Year | Integer | |
| MonthNumber | Integer | |
| MonthName | Text | |
| Quarter | Text | e.g. "Q1" |
| DayOfWeek | Text | |

## FactStrategyPlan
The fact table — financial amounts by account, scenario, and date.

| Column | Type | Description |
|---|---|---|
| Datekey | Date | FK to DimDate |
| ScenarioKey | Integer | FK to DimScenario |
| AccountKey | Integer | FK to DimAccount |
| Amount | Decimal | Raw (unsigned) financial amount |
| Signed Value | Decimal | Calculated column: Amount × CumulativeSign — the correctly signed amount used in all P&L measures |

**Columns dropped from the source** (not needed for this finance-only scope): `EntityKey`, `CurrencyKey` (confirmed single-currency via SQL), `ProductCategoryKey` (sales-side dimension), `StrategyPlanKey`, and ETL audit columns (`ETLLoadID`, `LoadDate`, `UpdateDate`).

## Key Measures

| Measure | Description |
|---|---|
| Signed Amount | SUM of Signed Value, all scenarios combined |
| Signed Actual Amount | Signed Amount filtered to Actual |
| Signed Budget Amount | Signed Amount filtered to Budget |
| Signed Budget Variance | Actual − Budget |
| Signed Budget Variance % | Variance ÷ Budget |
| Variance Status | "Favorable" / "Unfavorable" based on variance sign |
| Actual/Budget/Variance (Display) | Depth-aware versions used in the Matrix, returning blank below an account's real hierarchy depth to prevent duplicate rows on ragged branches |
| Signed Actual/Budget YoY % | Year-over-year change, via `SAMEPERIODLASTYEAR` |