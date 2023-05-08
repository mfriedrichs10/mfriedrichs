CREATE VIEW HousingSummary AS
SELECT
	UniqueID,
	ParcelID,
	IIF(LandUse = 'SINGLE FAMILY' 
		OR LandUse = 'DUPLEX' 
		OR LandUse = 'MOBILE HOME' 
		OR LandUse = 'VACANT RESIDENTIAL LAND', 'RESIDENTIAL', 'COMMERCIAL') 
	AS PropertyType,
	StreetNumber,
	StreetName,
	City,
	OwnerName,
	DATEDIFF(year, CompletionDateNEW, GETDATE()) AS AgeOfHome,
	CASE
		WHEN Acreage >= 10 THEN 'VERY LARGE'
		WHEN Acreage >= 3  THEN 'LARGE'
		WHEN Acreage >= 1  THEN 'MEDIUM'
		ELSE 'SMALL'
	END AS LotSize,
	FORMAT(LandValue + BuildingValue,'C0') AS TotalValue,
	FORMAT(SalePrice,'C0') AS SalePrice,
	YEAR(SaleDateNew) AS Year,
	DATENAME(Month, SaleDateNew) AS Month,
	FORMAT(SalePrice - (LandValue + BuildingValue),'C0') AS Profit_Loss
FROM Housing.dbo.HousingData


SELECT * 
FROM HousingSummary