-- Check Tables and Indexes compression
SELECT 
	  t.name AS TableName
	, ISNULL([i].[name],'HEAP') AS IndexName
	, p.partition_number AS PartitionNumber
	, p.data_compression_desc AS CompressionType
FROM [sys].[partitions] AS [p]
INNER JOIN sys.tables AS [t] ON [t].[object_id] = [p].[object_id]
INNER JOIN sys.indexes AS [i] ON [i].[object_id] = [p].[object_id] AND [i].[index_id] = [p].[index_id]