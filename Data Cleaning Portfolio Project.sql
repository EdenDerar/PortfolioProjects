/*
Cleaning data in SQL Quries
*/
Select * 
From [Portofolio Project].dbo.NashvilleHousing


-- Standardize Date Format 
Select SaleDateConverted, CONVERT (date,SaleDate)
From [Portofolio Project].dbo.NashvilleHousing

--UPDATE NashvilleHousing, DIDN'T WORK
--SET SaleDate = CONVERT (date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (date,SaleDate)




-- Populate Property Address data
SELECT *
FROM [Portofolio Project].dbo.NashvilleHousing
--WHERE PropertyAddress is null
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portofolio Project].dbo.NashvilleHousing a
JOIN [Portofolio Project].dbo.NashvilleHousing b
      ON a.ParcelID = b.ParcelID
	  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portofolio Project].dbo.NashvilleHousing a
JOIN [Portofolio Project].dbo.NashvilleHousing b
      ON a.ParcelID = b .ParcelID
	  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
From [Portofolio Project].dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address

From [Portofolio Project].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD	PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) AS Address

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = , SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address

SELECT *
FROM [Portofolio Project].dbo.NashvilleHousing
---
Select OwnerAddress
FROM [Portofolio Project].dbo.NashvilleHousing

Select 
Parsename (REPLACE(OwnerAddress,',' , '.'),3)
,Parsename (REPLACE(OwnerAddress,',' , '.'),2)
,Parsename (REPLACE(OwnerAddress,',' , '.'),1)
FROM [Portofolio Project].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD	OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = Parsename (REPLACE(OwnerAddress,',' , '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = Parsename (REPLACE(OwnerAddress,',' , '.'),2)

ALTER TABLE NashvilleHousing
ADD	OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = Parsename (REPLACE(OwnerAddress,',' , '.'),1)




-- Change Y and N to Yes and No in "Sold as Vacant" field
Select DISTINCT (SoldAsVacant), COUNT (SoldAsVacant)
From [Portofolio Project].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
       END
FROM [Portofolio Project].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
       END

Select * 
From [Portofolio Project].dbo.NashvilleHousing



-- Remove Duplicates
WITH RowNumCTE AS(
Select * ,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference,
	             ORDER BY
				    UniqueID
					) row_num
From [Portofolio Project].dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
WHERE row_num > 1
Order by PropertyAddress

--TO DELETE
DELETE *
From RowNumCTE
WHERE row_num > 1




-- Delete Unused Columns
Select * 
From [Portofolio Project].dbo.NashvilleHousing

ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate































