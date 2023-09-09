/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.nashvillehousingg;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
SELECT SaleDate, Cast(SaleDate as DATE)
FROM PortfolioProject.nashvillehousingg;

UPDATE nashvillehousingg
SET
SaleDate = Cast(SaleDate as DATE);



-- If it doesn't Update properly

ALTER TABLE nashvillehousingg
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CAST(SaleDate AS DATE);


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select PropertyAddress
From PortfolioProject.nashvillehousingg
Where PropertyAddress = ''
order by ParcelID;



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
(
SELECT 
case 
when  a.PropertyAddress = '' then  b.PropertyAddress
end) as newcolumn
From PortfolioProject.nashvillehousingg a
JOIN PortfolioProject.nashvillehousingg b
	on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress = '';


Update PortfolioProject.nashvillehousingg a
JOIN PortfolioProject.nashvillehousingg b 
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress =  b.Propertyaddress 
Where a.PropertyAddress = '';

-- Breaking out Address iunto Indivdual columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.nashvillehousingg;

SELECT 
SUBSTRING(PropertyAddress, 1, LOCATE(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1, length(PropertyAddress)) as Address
FROM PortfolioProject.nashvillehousingg;

ALter TABLE nashvillehousingg
ADD PropertySplitAddress NVARCHAR(255);

UPDATE nashvillehousingg 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',',PropertyAddress)-1);

ALter TABLE nashvillehousingg
ADD PropertySplitCity NVARCHAR(255);

UPDATE nashvillehousingg 
SET PropertySplitCity = SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1, length(PropertyAddress));


SELECT *
FROM PortfolioProject.nashvillehousingg;


SELECT OwnerAddress
FROM PortfolioProject.nashvillehousingg;


 SELECT
substr(OwnerAddress, 1, trim(length(OwnerAddress) - length(substring_index(OwnerAddress, ',', -2))-1)) street,
  substring_index(substring_index(OwnerAddress, ',', -2), ',', 1) city,
  substr(trim(substring_index(OwnerAddress, ',', -1)),1,2) state
FROM PortfolioProject.nashvillehousingg;




ALter TABLE nashvillehousingg
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE nashvillehousingg 
SET  OwnerSplitAddress = substr(OwnerAddress, 1, trim(length(OwnerAddress) - length(substring_index(OwnerAddress, ',', -2))-1));



ALter TABLE nashvillehousingg
ADD OwnerSplitCity NVARCHAR(255);

UPDATE nashvillehousingg 
SET OwnerSplitCity = substring_index(substring_index(OwnerAddress, ',', -2), ',', 1);



ALter TABLE nashvillehousingg
ADD OwnerSplitState NVARCHAR(255);

UPDATE nashvillehousingg 
SET OwnerSplitState =  substr(trim(substring_index(OwnerAddress, ',', -1)),1,2);


-- Change Y and N to Yes and No in "Sold as Vacant' field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.nashvillehousingg
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT
*
FROM 
nashvillehousingg;


SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' Then 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject.nashvillehousingg;


UPDATE nashvillehousingg
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' Then 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END; 

 
SELECT SoldAsVacant 
FROM 
nashvillehousingg;
 
 INSERT INTO nashvillehousingg(SoldAsVacant)
 SELECT 
 SoldAsVacant
 FROM NashvilleHousing
 where SoldAsVacant = NULL;
 
 
 UPDATE nashvillehousingg
JOIN NashvilleHousing on nashvillehousingg.UniqueID = NashvilleHousing.UniqueID
 SET nashvillehousingg.SoldAsVacant = NashvilleHousing.SoldAsVacant;
 
 
 -- Remove duplicates
 
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY 
UniqueID
) row_num
FROM PortfolioProject.nashvillehousingg
order by ParcelID;

Error Code: 1205. Lock wait timeout exceeded; try restarting transaction

SELECT case when nashvillehousingg.SoldAsVacant is null then NashvilleHousing.SoldAsVacant else nashvillehousingg.SoldAsVacant end as id
FROM
nashvillehousingg
JOIN NashvilleHousing on (nashvillehousingg.UniqueID = NashvilleHousing.UniqueID);


