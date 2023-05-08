USE Housing;
GO


SELECT *
FROM HousingData


/* Display a summary of the HousingData table */


EXEC sp_help HousingData


/* Convert the SaleDate and CompletionDate type from datetime to date */

ALTER TABLE HousingData
ADD SaleDateNew Date;

UPDATE HousingData
SET SaleDateNew = CONVERT(Date,SaleDate)

ALTER TABLE HousingData
ADD CompletionDateNew Date;

UPDATE HousingData
SET CompletionDateNew = CONVERT(Date,CompletionDate)


/* Identify all records where the Property Address is NULL and use a self join to find the 
address from past sales records. Update the NULL values. */


SELECT *
FROM HousingData
WHERE PropertyAddress is null


SELECT 
	a.ParcelID, 
	a.PropertyAddress,
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingData AS a
JOIN HousingData AS b ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingData AS a
JOIN HousingData AS b ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


/* Find all values with a "double space" in the PropertyAddress column and replace with a single space */


UPDATE HousingData
SET PropertyAddress = REPLACE(PropertyAddress, '  ', ' ');


/* Split the PropertyAddress column into three separate columns: 'StreetNumber', 'StreetName' and 'City' */


SELECT PropertyAddress
FROM HousingData


SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(' ', PropertyAddress) -1 ) AS StreetNumber,
	SUBSTRING(PropertyAddress, CHARINDEX(' ',PropertyAddress)+1,(((LEN(PropertyAddress))-CHARINDEX(',', REVERSE(PropertyAddress)))- CHARINDEX(' ',PropertyAddress))) AS StreetName,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS City
FROM HousingData

ALTER TABLE HousingData
ADD StreetNumber NVARCHAR(10);

UPDATE HousingData
SET StreetNumber = SUBSTRING(PropertyAddress, 1, CHARINDEX(' ', PropertyAddress) -1 )


ALTER TABLE HousingData
ADD StreetName NVARCHAR(255);

UPDATE HousingData
SET StreetName = SUBSTRING(PropertyAddress, CHARINDEX(' ',PropertyAddress)+1,(((LEN(PropertyAddress))-CHARINDEX(',', REVERSE(PropertyAddress)))- CHARINDEX(' ',PropertyAddress)))

ALTER TABLE HousingData
ADD City NVARCHAR(50);

UPDATE HousingData
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


/* Convert any 'Y' or 'N' values in the SoldAsVacant column to 'Yes' or 'No' */

UPDATE HousingData
SET SoldAsVacant = CASE 
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

SELECT DISTINCT
	SoldAsVacant,
	COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant


/* Identify all rows that contain duplicate data and delete all of the duplicate rows from the table */


WITH 
	RowNum AS
		(SELECT *,
		ROW_NUMBER() OVER (PARTITION BY 
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
		ORDER BY UniqueID) AS DuplicateCount
		FROM HousingData)

--SELECT *
DELETE
FROM RowNum
WHERE DuplicateCount > 1


/* Delete Unused Columns */


SELECT *
FROM HousingData

ALTER TABLE HousingData
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate, CompletionDate
