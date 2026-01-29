USE Breweries

SELECT * FROM Breweries;
SELECT * FROM Brewery_Data;

-- TABLE Breweries
-- NULL VALUES (except in website)
SELECT * FROM Breweries
WHERE 
	brewery_key IS NULL OR
	brewery_name IS NULL OR
	type IS NULL OR
	address IS NULL;


-- Blank fields (except in website)
SELECT * FROM Breweries
WHERE 
	brewery_key NOT LIKE '%_%' OR
	brewery_name NOT LIKE '%_%' OR
	type NOT LIKE '%_%' OR
	address NOT LIKE '%_%';


-- TABLE Brewery Data -

-- NULL VALUES (except in website)
SELECT * FROM Brewery_Data
WHERE 
	brewery_key IS NULL OR
	costs IS NULL OR
	sales IS NULL OR
	employees IS NULL OR
	barrels IS NULL;


-- Blank fields (except in website)
SELECT * FROM Brewery_Data
WHERE 
	brewery_key NOT LIKE '%_%' OR
	costs NOT LIKE '%_%' OR
	sales NOT LIKE '%_%' OR
	employees NOT LIKE '%_%' OR
	barrels NOT LIKE '%_%';



-- Create new table from the Cleaning and preparation query
SELECT 
	BrewData.brewery_key AS 'Brewery Key', 
	Brew.brewery_name AS Name, 
	CASE
		WHEN Brew.brewery_name LIKE '% - %' THEN LEFT(brewery_name, CHARINDEX(' - ', brewery_name)-1)  
		WHEN Brew.brewery_name LIKE '%(%' THEN LEFT(brewery_name, CHARINDEX('(', brewery_name)-1) 
		WHEN Brew.brewery_name LIKE '%#%' THEN LEFT(brewery_name, CHARINDEX('#', brewery_name)-1)
		ELSE Brew.brewery_name
	END	AS 'Brewery Company Name',

	CASE
		WHEN Brew.type LIKE '%-Closed%' THEN REPLACE(Brew.type, '-Closed','')
		WHEN Brew.type='Contract' OR Brew.type='ContractBrewery'THEN 'Contract Brewery'
		WHEN Brew.type='RegionalBrewery' THEN 'Regional Brewery'
		WHEN Brew.type='MultitapBar' THEN 'Multitap Bar'
		WHEN Brew.type='BOP-BrewOnPremise' THEN 'BOP Brew On Premise'
		ELSE Brew.type
	END AS 'Brewery type',     

	CASE
		WHEN Brew.type LIKE '%-Closed%' THEN 'Closed'
		ELSE 'Open'
	END AS 'Closed or Open',       
	Brew.address AS 'Address', 
	CASE
		-- WHEN Brew.state LIKE '%-%' THEN REPLACE(Brew.state, '-','')
		WHEN Brew.state='new-hampshire' THEN 'New Hampshire'
		WHEN Brew.state='new-jersey' THEN 'New Jersey'
		WHEN Brew.state='new-mexico' THEN 'New Mexico'
		WHEN Brew.state='new-york' THEN 'New York'
		WHEN Brew.state='north-carolina' THEN 'North Carolina'
		WHEN Brew.state='north-dakota' THEN 'North Dakota'
		WHEN Brew.state='puerto-rico' THEN 'Puerto Rico'
		WHEN Brew.state='rhode-island' THEN 'Rhode Island'
		WHEN Brew.state='south-carolina' THEN 'South Carolina'
		WHEN Brew.state='south-dakota' THEN 'South Dakota'
		WHEN Brew.state='washington-dc' THEN 'Washington DC'
		WHEN Brew.state='west-virginia' THEN 'West Virginia'
		ELSE CONCAT(UPPER(LEFT(Brew.state,1)),RIGHT(Brew.state,LEN(Brew.state)-1))
	END AS State,

	BrewData.costs AS Costs, 
	BrewData.sales AS Sales, 
	BrewData.employees AS Employees, 
	BrewData.barrels AS Barrels

INTO Brew_AllData

FROM Brewery_Data BrewData
INNER JOIN Breweries Brew
ON Brew.brewery_key = BrewData.brewery_key;

SELECT * FROM Brew_AllData;