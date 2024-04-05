-- Read a json file as a table
-- Sample of Json File:
-- [
--    {
--        "lat": 51.52916347,
--        "lon": -0.109970527,
--        "longStationId": "1",
--        "stationId": "001023",
--        "stationName": "River Street , Clerkenwell"
--    },
--    {
--        "lat": 51.49960695,
--        "lon": -0.197574246,
--        "longStationId": "2",
--        "stationId": "001018",
--        "stationName": "Phillimore Gardens, Kensington"
--    },
--...
--]


SELECT station.stationId,station.lat,station.lon,station.stationName
FROM OPENROWSET(BULK 'D:\santander\stations.json', SINGLE_CLOB) AS j
CROSS APPLY OPENJSON(BulkColumn) WITH (
    lat decimal(10,8),
    lon decimal(10,8),
    longStationId FLOAT,
    stationId varchar(53),
    stationName varchar(max)
) AS station;


-- =======================================================================================================================================================================================================



-- Geting List Of Tables and their columns and replace null with 0
-- For, Temp Table, All Table Names, All Column Name, 





declare @columnValue as nvarchar(30)
declare @columnValue2 as nvarchar(30)
DECLARE @SQL NVARCHAR(MAX)
SET @SQL = ''
    
	DECLARE cursorItem CURSOR FOR 
		SELECT
			TABLE_NAME
		FROM #TempTables 
	OPEN cursorItem;
	FETCH NEXT FROM cursorItem INTO @columnValue;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	print (@columnValue)
				DROP Table #temp
				SELECT Distinct COLUMN_NAME INTO #temp
				FROM [tripsmanagement].INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = @columnValue
				DECLARE cursorItem2 CURSOR FOR 
					SELECT
					COLUMN_NAME
					FROM #temp 
				OPEN cursorItem2;

				WHILE @@FETCH_STATUS = 0
				BEGIN
		
					print ('     '+@columnValue2)

					SET @SQL = 'update [tripsmanagement].[trips].[' + @columnValue + '] set [' + @columnValue2 + '] = 0 where [' + @columnValue2 + '] is null'
					EXEC(@SQL)
					--print(@SQL)
					print('				DONE')

				FETCH NEXT FROM cursorItem2 INTO @columnValue2;

				END
				CLOSE cursorItem2;
				DEALLOCATE cursorItem2;
		FETCH NEXT FROM cursorItem INTO @columnValue;
		END
		CLOSE cursorItem;

		DEALLOCATE cursorItem


-- =======================================================================================================================================================================================================

