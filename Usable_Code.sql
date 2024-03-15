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
